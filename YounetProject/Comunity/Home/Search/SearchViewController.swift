//
//  SearchViewController.swift
//  YounetProject
//
//  Created by 조혠 on 1/12/24.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    //API
    var searchData: [SearchModel] = []
    var countryId: Int?
    var categoryId: Int?
    var keyword: String?
    
    override func viewDidLoad() {
        self.textField.delegate = self
        cancelButton.layer.cornerRadius = 5
        
        super.viewDidLoad()

    }
    //셀 등록
    private func registerXib() {
        let nibName = UINib(nibName: "SearchCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "SearchCell")
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    @objc func more(_ sender: UIButton){
        guard let searchDetailVC = storyboard?.instantiateViewController(identifier: "SearchDetailVC") as? SearchDetailViewController else{
            return
        }
        searchDetailVC.setId((self.countryId, self.categoryId, self.keyword))
        searchDetailVC.modalPresentationStyle = .fullScreen
        present(searchDetailVC, animated: true, completion: nil)
    }
    func setCountryId(_ id: Int) {
            self.countryId = id
        }
    func tableViewLoad(){
        registerXib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        textField.text = keyword
    }
    func getData(_ keyword: String){
        self.keyword = keyword
        let url = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/community/search/\(keyword)/\(countryId!)"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [SearchModel].self) {  response in
                switch response.result {
                case .success(let search):
                    self.searchData.append(contentsOf: search)
                    self.tableViewLoad()                    
                case .failure(let error):
                    print("SearchError: \(error)")
                }
            }
    }
}
extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.filter { $0.postListResultDTOS?.count ?? 0 > 0 }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchCell else{return UITableViewCell()}
        let filteredData = searchData.filter { $0.postListResultDTOS?.count ?? 0 > 0 }
        let search = filteredData[indexPath.row]
        cell.categoryLabel.text = search.categoryName
        cell.titleLabel1.text = search.postListResultDTOS?.first?.title
        cell.contentLabel1.text = search.postListResultDTOS?.first?.bodySample
        cell.timeLabel1.text = String(search.postListResultDTOS?.first?.createdAt?.prefix(10) ?? "")
        cell.likeLabel1.text = "\(String(describing: search.postListResultDTOS?.first?.likesCount ?? 0))"
        cell.commentLabel1.text = "\(String(describing: search.postListResultDTOS?.first?.commentsCount ?? 0))"
        switch(search.categoryName!){
        case "유학생활":
            self.categoryId = 1
            break
        case "유학준비":
            self.categoryId = 2
            break
        case "중고거래":
            self.categoryId = 3
            break
        case "여행":
            self.categoryId = 4
            break
        default:
            self.categoryId = 5
            break
        }
        if search.postListResultDTOS?.count == 2{
            if let secondPost = search.postListResultDTOS?[1] {
                    cell.titleLabel2.text = secondPost.title
                    cell.contentLabel2.text = secondPost.bodySample
                    cell.timeLabel2.text = String(secondPost.createdAt?.prefix(10) ?? "")
                    cell.likeLabel2.text = "\(secondPost.likesCount ?? 0)"
                    cell.commentLabel2.text = "\(secondPost.commentsCount ?? 0)"
                }
        }
        
        cell.moreButton.addTarget(self, action: #selector(more(_:)), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
}
extension SearchViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textField{
            let keyword = textField.text!
            textField.resignFirstResponder()
            getData(keyword)
        }
        return true
    }
}
