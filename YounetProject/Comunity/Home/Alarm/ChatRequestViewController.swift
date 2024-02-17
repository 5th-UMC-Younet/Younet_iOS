//
//  ChatRequsetViewController.swift
//  YounetProject
//
//  Created by 조혠 on 2/2/24.
//

import UIKit
import Alamofire

class ChatRequestViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    //API
    var requestData:[ChatRqModel] = []
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    override func viewDidLoad() {
        getData()
        
        super.viewDidLoad()
    }
    //셀 등록
    private func registerXib() {
        let nibName = UINib(nibName: "ChatRqCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "ChatRqCell")
    }
    //MARK: - TableView
    func tableViewLoad(){
        registerXib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    //MARK: - API
    func getData(){
        let url = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/alarm/chatRequest/4"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ChatRqModel.self) { response in
                switch response.result {
                case .success(let chatRq):
                    self.requestData.append(chatRq)
                    self.tableViewLoad()
                case .failure(let error):
                    print("ChatRqError: \(error)")
                }
            }
    }
    func acceptRequest(at indexPath: IndexPath, chatAlarmId: Int){
        
        print("수락")
    }
    func rejectRequest(at indexPath: IndexPath, chatAlarmId: Int){
        let url = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080//chatTemp/refuse/\(chatAlarmId)"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ChatRqModel.self) { response in
                switch response.result {
                case .success(_):
                    self.tableViewLoad()
                case .failure(let error):
                    print("ChatRejectError: \(error)")
                }
            }
        print("거절")
    }
}

//MARK: - extension
extension ChatRequestViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if requestData.isEmpty {
            return 0
        } else {
            return requestData[0].content.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRqCell", for: indexPath) as? ChatRqCell else{return UITableViewCell()}
        let request = requestData[0].content[indexPath.row]
        cell.dateLabel.text = String(request.createdAt.prefix(10))
        cell.userButton.setTitle(request.requesterName, for: .normal)
        cell.onAcceptButtonTapped = {[weak self] in
            self?.acceptRequest(at: indexPath, chatAlarmId: (request.chatAlarmId))
        }
        cell.onRejectButtonTapped = {[weak self] in
            self?.rejectRequest(at: indexPath, chatAlarmId: (request.chatAlarmId))
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

