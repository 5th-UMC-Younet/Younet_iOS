//
//  OpenSearchViewController.swift
//  YounetProject
//
//  Created by 조혠 on 2/4/24.
//

import UIKit
import Alamofire

class OpenSearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var groupLabel: UILabel!

    var searchData: [OpenSearchModel] = []
    var keyword: String?
    override func viewDidLoad() {
        self.textField.delegate = self
        groupLabel.text = ""
        super.viewDidLoad()
    }
    private func registerXib() {
        let nibName = UINib(nibName: "OpenSearchCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "OpenSearchCell")
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    func tableViewLoad(){
        registerXib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    //MARK: - API
    func getData(_ keyword: String){
        self.keyword = keyword
        let url = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/community/"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [OpenSearchModel].self) {  response in
                switch response.result {
                case .success(let search):
                    self.searchData.append(contentsOf: search)
                    self.tableViewLoad()
                case .failure(let error):
                    print("OpenSearchError: \(error)")
                }
            }
    }
}
extension OpenSearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OpenSearchCell", for: indexPath) as? OpenSearchCell else{return UITableViewCell()}
        let search = searchData[indexPath.row]
        cell.titleLabel.text = search.title
        cell.messageLabel.text = search.message
        cell.participantLabel.text = "\(String(describing: search.participants))"
        let url = URL(string: search.thumbnail!)
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imgView.image = image
                    }
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
extension OpenSearchViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textField{
            let keyword = textField.text!
            groupLabel.text = "그룹채팅"
            textField.resignFirstResponder()
            getData(keyword)
        }
        return true
    }
}
