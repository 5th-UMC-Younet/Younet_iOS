//
//  HomeViewController.swift
//  YounetProject
//
//  Created by 조혠 on 1/9/24.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var sortButton: [UIButton]!
    
    //카테고리
    @IBOutlet var category: [UIButton]!
    var index: Int?
    //국가 선택
    @IBOutlet weak var countryName: UIButton!
    @IBOutlet weak var engCountryName: UILabel!
    @IBOutlet weak var countryImg: UIImageView!
    
    //API
    var feedData: [FeedModel] = []
    var countryId = 1
    var categoryId = 1
    var sortId = 1 //1 = 최신순 2 = 좋아요순
    var name = "덴마크" //나라이름
    
    let countries: [Country] = [
        Country(name: "덴마크", engName: "DENMARK", img: "🇩🇰"),
        Country(name: "독일", engName: "GERMANY", img: "🇩🇪"),
        Country(name: "미국", engName: "UNITED STATES", img: "🇺🇸"),
        Country(name: "벨기에", engName: "BELGIUM", img: "🇧🇪"),
        Country(name: "브라질", engName: "BRAZIL", img: "🇧🇷"),
        Country(name: "스웨덴", engName: "SWEDEN", img: "🇸🇪"),
        Country(name: "스위스", engName: "SWITZERLAND", img: "🇨🇭"),
        Country(name: "스페인", engName: "SPAIN", img: "🇪🇸"),
        Country(name: "영국", engName: "UNITED KINGDOM", img: "🇬🇧"),
        Country(name: "오스트리아", engName: "AUSTRIA", img: "🇦🇹"),
        Country(name: "이탈리아", engName: "ITALY", img: "🇮🇹"),
        Country(name: "일본", engName: "JAPAN", img: "🇯🇵"),
        Country(name: "중국", engName: "CHINA", img: "🇨🇳"),
        Country(name: "캐나다", engName: "CANADA", img: "🇨🇦"),
        Country(name: "프랑스", engName: "FRANCE", img: "🇫🇷"),
        Country(name: "핀란드", engName: "FINLAND", img: "🇫🇮"),
        Country(name: "호주", engName: "AUSTRALIA", img: "🇦🇺"),
        Country(name: "멕시코", engName: "MEXICO", img: "🇲🇽"),
        Country(name: "네덜란드", engName: "NETHERLANDS", img: "🇳🇱")
    ]
    
    override func viewDidLoad() {
        getAPI()
        //정렬 초기값
        sortButton[0].isSelected = true
        //카테고리 초기값
        category[self.categoryId-1].isSelected = true
        index = 0
        
        super.viewDidLoad()
    }
    //MARK: - ALarm
    @IBAction func alarm(_ sender: Any) {
        guard let alarmVC = storyboard?.instantiateViewController(identifier: "AlarmVC") as? AlarmViewController else{
            return
        }
        alarmVC.modalPresentationStyle = .fullScreen
        present(alarmVC, animated: true, completion: nil)
    }
    
    //MARK: - Search
    @IBAction func search(_ sender: Any) {
        guard let searchVC = storyboard?.instantiateViewController(identifier: "SearchVC") as? SearchViewController else{
            return
        }
        searchVC.modalPresentationStyle = .fullScreen
        searchVC.setCountryId(self.countryId)
        present(searchVC, animated: true, completion: nil)
    }
    
    //MARK: - Sort
    @IBAction func sort(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        for button in sortButton where button != sender {
            button.isSelected = false
        }
        if sender.isSelected {
            index = sortButton.firstIndex(of: sender)
        } else {
            index = nil
        }
        if sortButton[0].isSelected{
            sortId = 1
        }else{
            sortId = 2
        }
        getAPI()
    }
    
    
    //MARK: - Category
    @IBAction func touchButton(_ sender: UIButton) {
        if index != nil {
            if !sender.isSelected{
                for index in category.indices {
                    category[index].isSelected = false
                }
                sender.isSelected = true
                index = category.firstIndex(of: sender)
            }
        }else{
            sender.isSelected = true
            index = category.firstIndex(of: sender)
        }
    }
    //카테고리 선택시 데이터 reload
    @IBAction func life(_ sender: Any) {
        reloadTableView(data: "life")
    }
    @IBAction func prepare(_ sender: Any) {
        reloadTableView(data: "prepare")
    }
    @IBAction func trade(_ sender: Any) {
        reloadTableView(data: "trade")
    }
    @IBAction func travel(_ sender: Any) {
        reloadTableView(data: "travel")
    }
    @IBAction func etc(_ sender: Any) {
        reloadTableView(data: "etc")
    }
    func reloadTableView(data: String){
        switch data{
        case "life":
            self.categoryId = 1
            getAPI()
            break
        case "prepare":
            self.categoryId = 2
            getAPI()
            break
        case "trade":
            self.categoryId = 3
            getAPI()
            break
        case "travel":
            self.categoryId = 4
            getAPI()
            break
        case "etc":
            self.categoryId = 5
            getAPI()
            break
        default:
            break
        }
    }
    
    //MARK: - CountrySelection
    @IBAction func CountrySelection(_ sender: Any) {
        let nationSelectionVC = NationSelectionVC.present(parent: self)
        nationSelectionVC.onDismissed = { [weak self] () in
            let countryInfo = nationSelectionVC.selectedCountry
            var engName: String = ""
            
            for i in  0..<(self?.countries.count ?? 0)  {
                if self?.countries[i].name == countryInfo?.korName {
                    engName = self?.countries[i].engName ?? ""
                    self!.countryId = i+1
                }
            }
            self?.countryName.setTitle(countryInfo?.korName, for: .normal)
            self?.engCountryName.text = engName
            self?.countryImg.image = UIImage(named: countryInfo?.engName ?? "")
            self?.name = countryInfo!.korName
            self?.getAPI()
        }
        
    }
    
    //MARK: - TableView
    private func registerXib() {
        let nibName = UINib(nibName: "FeedCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "FeedCell")
    }
    func tableViewLoad(){
        self.registerXib()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    //MARK: - API
    func  getAPI(){
        if feedData.isEmpty {
            if sortId == 1{
                getDataByDates()
            } else {
                getDataByLikes()
            }
        } else {
            feedData.remove(at: 0)
            if sortId == 1{
                getDataByDates()
            } else {
                getDataByLikes()
            }
        }
    }
    func getDataByDates() {
        let url = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/community/\(countryId)/\(categoryId)/byDates"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: FeedModel.self) { response in
                switch response.result {
                case .success(let feed):
                    self.feedData.append(feed)
                    self.tableViewLoad()
                    print(self.countryId,self.categoryId)
                case .failure(let error):
                    print("FeedError: \(error)")
                }
            }
    }
    func getDataByLikes() {
        let url = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/community/\(countryId)/\(categoryId)/byLikes"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: FeedModel.self) { response in
                switch response.result {
                case .success(let feed):
                    self.feedData.append(feed)
                    self.tableViewLoad()
                case .failure(let error):
                    print("FeedError: \(error)")
                }
            }
    }
    //MARK: - timeCalculate
    func timeAgo(from dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString) {
            let now = Date()
            let components = Calendar.current.dateComponents([.hour, .minute, .day, .month, .year], from: date, to: now)
            
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

//MARK: - Extension
extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    //셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedData[0].content.count
    }
    
    //셀 종류
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedCell else{return UITableViewCell()}
        let feed = feedData[0].content[indexPath.row]
        cell.titleLabel.text = feed.title
        cell.contentLabel.text = feed.bodySample
        cell.likeLabel.text = "좋아요 \(feed.likesCount)"
        cell.commentLabel.text = "댓글 \(feed.commentsCount)"
        //Image
        let url = URL(string: feed.imageSampleUrl)
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imgView.image = image
                    }
                }
            }
        }
        //Time
        let dateString = feed.createdAt
        if let timeAgo = timeAgo(from: dateString) {
            cell.timeLabel.text = "\(timeAgo)"
        } else {
            print("TimeError")
        }
        return cell
    }
    //테이블뷰 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    //데이터 전달
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postId = feedData[0].content[indexPath.row].postId
        let date = feedData[0].content[indexPath.row].createdAt
        let senderData: (Int,Int,String,String) = (postId,categoryId,date,name)
        performSegue(withIdentifier: "DetailVC", sender: senderData)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailVC" {
            let vc = segue.destination as? DetailViewController
            if let senderData = sender as? (Int, Int,String,String) {
                vc?.postId = senderData.0
                vc?.categoryId = senderData.1
                vc?.date = senderData.2
                vc?.countryName = senderData.3
                vc?.modalPresentationStyle = .fullScreen
            }
        }
    }
    
    
}
