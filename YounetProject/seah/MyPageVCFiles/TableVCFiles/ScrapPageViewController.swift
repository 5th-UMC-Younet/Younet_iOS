//
//  ScrapPageViewController.swift
//  YounetProject
//
//  Created by 김세아 on 2/14/24.
//

import UIKit
import Alamofire

class ScrapPageViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var feedData: [MyPageUserData] = []
    var page = 1
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        getAPI()
    }
    
    // FeedCell register
    private func registerXib() {
        let nibName = UINib(nibName: "FeedCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "FeedCell")
    }
    
    // 갱신용. 특정 개수 이상 시 아래로 swipe했을 때 갱신
    @IBAction func more(_ sender: UIButton) {
        // 0) 현재 페이지 값에 1을 추가한다.
        self.page += 1
        
        // 데이터를 다시 읽어오도록 테이블 뷰를 갱신한다.
        self.tableView.reloadData()
    }
    
    func tableViewLoad() {
        registerXib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
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
        let url = APIUrl.myPage
        let tk = TokenUtils()
        AF.request(url, method: .get, headers: tk.getAuthorizationHeader(serviceID: APIUrl.url))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: MyPageResponse<MyPageUserData>.self) { response in
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
}

extension ScrapPageViewController : UITableViewDelegate, UITableViewDataSource {
    
    //셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let feedCount: Int
        if feedData == [] {
            feedCount = 0
        } else {
            feedCount = feedData[0].scraps.count
        }
        return feedCount
    }
    
    //셀 디자인
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedCell else { return UITableViewCell() }
        let feed = feedData[0].scraps[indexPath.row]
        
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
    
    
    //데이터 전달
    //데이터 전달
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        let postId = feedData[0].posts[indexPath.row].postId
        let date = feedData[0].posts[indexPath.row].createdAt
        let categoryId = feedData[0].posts[indexPath.row].categoryId
        let senderData: (Int, Int, String) = (postId!, categoryId!, date!)
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
    }
    
}

