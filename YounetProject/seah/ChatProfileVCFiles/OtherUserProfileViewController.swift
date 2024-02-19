//
//  OtherUserProfileViewController.swift
//  YounetProject
//
//  Created by 김세아 on 2/6/24.
//

import UIKit
import Alamofire

class OtherUserProfileViewController: UIViewController {

    @IBOutlet weak var nickNameProfileImage: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var nationContainer: UIView!
    @IBOutlet weak var preferNationImage: UIImageView!
    @IBOutlet weak var preferNation: UILabel!
    @IBOutlet weak var nickNameSelfExplain: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    let simpleData = UserDefaults.standard
    let imageData = ImageFileManager.shared
    
    var feedData: [ChatOtherUserProfileData] = []
    var page = 1
    var index = 0
    var userIdInt = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        getAPI()
        
        setDesign()
        registerXib()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setDesign() {
        nationContainer.layer.borderColor = UIColor.lightGray.cgColor
        nationContainer.layer.borderWidth = 0.25
       
    }
    
    func tableViewLoad() {
        registerXib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    private func getData() {
        // 서버에서 받아와서 설정
        ChatOtherUserProfileService.shared.OtherUserProfile(userId: userIdInt){ (networkResult) -> (Void) in
            switch networkResult {
            case .success(let result):
                if let otherUserData = result as? ChatOtherUserProfileData {
                    // 프로필 세팅
                    self.nickName.text = otherUserData.name
                    otherUserData.profileText == nil ? (self.nickNameSelfExplain.text = "프로필 소개글") : (self.nickNameSelfExplain.text = otherUserData.profileText)
                    
                    // 관심 국가명 및 이미지 세팅
                    if self.simpleData.string(forKey: "preferNationImage") != nil {
                        self.preferNation.text = otherUserData.likeCntr
                        self.preferNationImage.image = UIImage(named: self.simpleData.string(forKey: "preferNationImage")!)
                        self.nationContainer.isHidden = false
                    } else {
                        self.preferNation.text = "관심국가"
                        self.nationContainer.isHidden = true
                    }
                    
                    if otherUserData.profilePicture != nil {
                        // url로부터 프로필 이미지 받아오기
                        let url = URL(string: otherUserData.profilePicture!)
                        self.nickNameProfileImage.load(url: url!)
                    }
                    
                }
            case .requestErr:
                print("400 Error")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    func getAPI(){
        if feedData.isEmpty {
            // feedData 배열이 비어있는 경우에는 API를 호출하여 데이터를 가져옵니다.
            getDataByDates()
        } else {
            // feedData 배열이 비어있지 않은 경우에는 첫 번째 요소를 제거하고 다시 API를 호출하여 데이터를 업데이트합니다.
            feedData.remove(at: 0)
            getDataByDates()
        }
    }
    
    func getDataByDates() {
        // MARK: - 유저 아이디 받아오기
        let userId = userIdInt
        let url = APIUrl.otherUserPage + "\(userId)"
        print(url)
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ChatProfileResponse<ChatOtherUserProfileData>.self) { response in
                switch response.result {
                case .success(let feed):
                    self.feedData.append(feed.result!)
                    self.tableViewLoad()
                case .failure(let error):
                    print("FeedError: \(error)")
                }
            }
    }
    
    func timeAgo(from dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // 사용하는 날짜 형식에 맞게 설정
        
        if let date = dateFormatter.date(from: dateString) {
            let now = Date()
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
            
            if let years = components.year, years > 0 {
                return "\(years)년 전"
            } else if let months = components.month, months > 0 {
                return "\(months)달 전"
            } else if let days = components.day, days > 0 {
                return "\(days)일 전"
            } else if let hours = components.hour, hours > 0 {
                return "\(hours)시간 전"
            } else if let minutes = components.minute, minutes > 0 {
                return "\(minutes)분 전"
            } else {
                return "방금 전"
            }
        } else {
            return nil
        }
    }
    
    private func registerXib() {
        let nibName = UINib(nibName: "FeedCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "FeedCell")
    }
    
    @IBAction func backButtonDidtap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension OtherUserProfileViewController : UITableViewDelegate, UITableViewDataSource {
    
    //셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let feedCount: Int
        if feedData == [] {
            feedCount = 0
        } else {
            feedCount =  feedData[0].posts.count
        }
        return feedCount
    }
    
    //셀 디자인
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedCell else { return UITableViewCell() }
        let feed = feedData[0].posts[indexPath.row]
        
        cell.titleLabel.text = feed.title
        cell.contentLabel.text = feed.bodySample
        cell.likeLabel.text = "좋아요 \(feed.likesCount!)"
        cell.commentLabel.text = "댓글 \(feed.commentsCount!)"
        
        //Image
        if feed.imageSampleUrl != nil {
            let url = URL(string: feed.imageSampleUrl!)
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.imageSampleView.image = image
                        }
                    }
                }
            }
        } else {
            cell.imageSampleView.image = nil
        }
        
        //Time
        let dateString = feed.createdAt
        if let timeAgo = timeAgo(from: dateString!) {
            cell.timeLabel.text = "\(timeAgo)"
        } else { print("TimeError") }
        
        return cell
        
    }
    
    //셀 세로 길이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    /*//데이터 전달
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        let postId = feedData[0].posts[indexPath.row].postId
        let date = feedData[0].content[indexPath.row].createdAt
        let senderData: (Int,Int,String) = (postId,categoryId,date)
        performSegue(withIdentifier: "DetailVC", sender: senderData)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailVC" {
            let vc = segue.destination as? DetailViewController
            if let senderData = sender as? (Int, Int, String) {
                vc?.postId = senderData.0
                vc?.categoryId = senderData.1
                vc?.date = senderData.2
                vc?.modalPresentationStyle = .fullScreen
            }
        }
    }*/
    
}
