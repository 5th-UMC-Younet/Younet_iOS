//
//  SearchDeatailViewController.swift
//  YounetProject
//
//  Created by 조혠 on 2/6/24.
//

import UIKit
import Alamofire

class SearchDetailViewController: UIViewController {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var sortButton: [UIButton]!
    @IBOutlet weak var textField: UITextField!
    
    var index: Int? //정렬
    var sortId = 1
    var keyword: String?
    var countryId: Int?
    var categoryId: Int?
    var searchDetailData: [SearchDetailModel] = []
    
    override func viewDidLoad() {
        self.textField.delegate = self
        sortButton[0].isSelected = true
        getAPI()
        super.viewDidLoad()
        
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    private func registerXib() {
        let nibName = UINib(nibName: "FeedCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "FeedCell")
    }
    func tableViewLoad(){
        registerXib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    //MARK: - sort
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
    //MARK: - API
    func setId(_ id: (Int?, Int?, String?)) {
        if let countryId = id.0, let categoryId = id.1, let keyword = id.2 {
            self.countryId = countryId
            self.categoryId = categoryId
            self.keyword = keyword
        }
    }
    func getAPI(){
        if searchDetailData.isEmpty {
            if sortId == 1{
                getDataByDates()
            } else {
                getDataByLikes()
            }
        } else {
            searchDetailData.remove(at: 0)
            if sortId == 1{
                getDataByDates()
            } else {
                getDataByLikes()
            }
        }
    }
    func getDataByDates(){
        let url = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/community/search/\(keyword!)/\(countryId!)/\(categoryId!)/byDates"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SearchDetailModel.self) {  response in
                switch response.result {
                case .success(let search):
                    self.searchDetailData.append(search)
                    self.loadData()
                    self.tableViewLoad()
                case .failure(let error):
                    print("SearchDetailError: \(error)")
                }
            }
    }
    func getDataByLikes(){
        let url = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/community/search/\(keyword!)/\(countryId!)/\(categoryId!)/byLikes"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SearchDetailModel.self) {  response in
                switch response.result {
                case .success(let search):
                    self.searchDetailData.append(search)
                    self.loadData()
                    self.tableViewLoad()
                case .failure(let error):
                    print("SearchDetailError: \(error)")
                }
            }
    }
    func loadData(){
        switch(categoryId!){
        case 1:
            categoryLabel.text = "유학생활"
            break
        case 2:
            categoryLabel.text = "유학준비"
            break
        case 3:
            categoryLabel.text = "중고거래"
            break
        case 4:
            categoryLabel.text = "여행"
            break
        default:
            categoryLabel.text = "기타"
            break
        }
        textField.text = keyword!
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

    func goSearch(data:String){
        guard let searchVC = storyboard?.instantiateViewController(identifier: "SearchVC") as? SearchViewController else{
            return
        }
        searchVC.setCountryId(self.countryId!)
        searchVC.getData(data)
        searchVC.modalPresentationStyle = .fullScreen
        present(searchVC, animated: true, completion: nil)
    }
}
extension SearchDetailViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDetailData[0].content!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedCell else{return UITableViewCell()}
        let search = searchDetailData[0].content![indexPath.row]
        cell.titleLabel.text = search.title
        cell.contentLabel.text = search.bodySample
        cell.likeLabel.text = "좋아요 \(String(describing: search.likesCount!))"
        cell.commentLabel.text = "댓글 \(String(describing: search.commentsCount!))"
        //Image
        let url = URL(string: search.imageSampleUrl!)
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imageSampleView.image = image
                    }
                }
            }
        }
        //Time
        let dateString = search.createdAt
        if let timeAgo = timeAgo(from: dateString!) {
            cell.timeLabel.text = "\(timeAgo)"
        } else {
            print("TimeError")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    //데이터 전달
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let search = searchDetailData[0].content![indexPath.row]
        let postId = search.postId
        let date = search.createdAt
        let senderData: (Int?,Int?,String?) = (postId,categoryId,date)
        performSegue(withIdentifier: "DetailVC", sender: senderData)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailVC" {
            let vc = segue.destination as? DetailViewController
            if let senderData = sender as? (Int, Int,String) {
                vc?.postId = senderData.0
                vc?.categoryId = senderData.1
                vc?.date = senderData.2
                vc?.modalPresentationStyle = .fullScreen
            }
        }
    }
}
extension SearchDetailViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textField{
            let keyword = textField.text!
            textField.resignFirstResponder()
            goSearch(data: keyword)
        }
        return true
    }
}
