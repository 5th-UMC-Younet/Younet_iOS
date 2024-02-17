//
//  OpenChatViewController.swift
//  YounetProject
//
//  Created by 조혠 on 2/4/24.
//

import UIKit
import Alamofire

class OpenChatViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var openData:[OpenChatModel] = []
    
    override func viewDidLoad() {
        getData()
        super.viewDidLoad()
    }
    private func registerXib() {
        let nibName = UINib(nibName: "OpenChatCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "OpenChatCell")
    }
    @IBAction func alarm(_ sender: Any) {
        guard let alarmVC = storyboard?.instantiateViewController(identifier: "OpenAlarmVC") as? OpenAlarmViewController else{
            return
        }
        alarmVC.modalPresentationStyle = .fullScreen
        present(alarmVC, animated: true, completion: nil)
    }
    @IBAction func search(_ sender: Any) {
        guard let searchVC = storyboard?.instantiateViewController(identifier: "OpenSearchVC") as? OpenSearchViewController else{
            return
        }
        searchVC.modalPresentationStyle = .fullScreen
        present(searchVC, animated: true, completion: nil)
    }
    func tableViewLoad(){
        registerXib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    //MARK: - API
    func getData(){
        let url = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/chat/list/open"
        let header: HTTPHeaders = [
            "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkb2pvbzU2QG5hdmVyLmNvbSIsIm5hbWUiOiJtaWEiLCJpZCI6MiwiZXhwIjoxNzA4MTYwNjQ4fQ.7VjfiIjko5PTRYnx7yaXgB4F_fcyxzQzp1dy1jCnglE"
        ]
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [OpenChatModel].self) { response in
                switch response.result {
                case .success(let open):
                    print(open)
                    self.openData.append(contentsOf:open)
                    self.tableViewLoad()
                    
                case .failure(let error):
                    print("OpenChatError: \(error)")
                }
            }
    }
}
extension OpenChatViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OpenChatCell", for: indexPath) as? OpenChatCell else{return UITableViewCell()}
        let open = openData[indexPath.row]
        cell.titleLabel.text = open.title
        cell.messageLabel.text = open.message
        cell.dateLabel.text = String(open.createdAt?.prefix(10) ?? "")
        cell.numLabel.text = "\(String(describing: open.participants!))"
        let url = URL(string: open.thumbnail!)
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
