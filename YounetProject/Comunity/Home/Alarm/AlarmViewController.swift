//
//  AlarmViewController.swift
//  YounetProject
//
//  Created by 조혠 on 1/12/24.
//

import UIKit
import Alamofire

//알림 삭제 테스트용
enum AlarmType: String, Codable {
    case like = "Like"
    case comment = "Comment"
    case follow = "Follow"
}

class AlarmViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var requestButton: UIButton!
    
    //API
    var alarmData: [AlarmModel] = []
    var requestData:[ChatRqModel] = []
    
    override func viewDidLoad() {
        getData()
        super.viewDidLoad()
        
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    @IBAction func requestChat(_ sender: Any) {
        guard let chatRqVC = storyboard?.instantiateViewController(identifier: "ChatRqVC") as? ChatRequestViewController else{
            return
        }
        chatRqVC.modalPresentationStyle = .fullScreen
        present(chatRqVC, animated: true, completion: nil)
    }
    //셀 등록
    private func registerXib() {
        let nibName = UINib(nibName: "AlarmCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "AlarmCell")
    }
    func tableViewLoad(){
        registerXib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
//MARK: - API
    func getData(){
        let url = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/alarm/community/1"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: AlarmModel.self) { [self] response in
                switch response.result {
                case .success(let alarmModel):
                    self.alarmData.append(alarmModel)
                    self.tableViewLoad()
                case .failure(let error):
                    print("AlarmError: \(error)")
                }
            }
        let url2 = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/alarm/chatRequest/4"
        AF.request(url2, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ChatRqModel.self) { response in
                switch response.result {
                case .success(let chatRq):
                    self.requestData.append(chatRq)
                    self.requestButton.setTitle("채팅요청 \(self.requestData[0].content.count)", for: .normal)
                case .failure(let error):
                    print("ChatRqError: \(error)")
                }
            }
    }

}
//MARK: - extexsion
extension AlarmViewController : UITableViewDelegate, UITableViewDataSource {
    //셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmData[0].content!.count
    }
    
    //셀 종류
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as? AlarmCell else{return UITableViewCell()}
        let alarm = alarmData.first?.content?[indexPath.row]
        let title = alarm?.postTitle
        let name = alarm?.actorName
        switch(alarm?.alarmType!){
        case "LIKE":
            cell.contentLabel.text = "\(name!)님이 '\(title!)' 글을 좋아합니다."
            break
        default:
            break
        }
        let dateString = (alarm?.createdAt)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "h:mm a"
            let formattedDateString = dateFormatter.string(from: date)
            cell.dateLabel.text = formattedDateString
        }
        
        cell.onDeleteButtonTapped = { [weak self] in
            self?.deleteAlarm(at: indexPath, alarmId: (alarm?.alarmId!)!)
        }
        return cell
    }
    func deleteAlarm(at indexPath: IndexPath, alarmId: Int) {
        let alarmId = alarmId
        alarmData.remove(at: 0)
        let url = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/alarm/delete/\(alarmId)"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: AlarmModel.self) { [self] response in
                switch response.result {
                case .success(let alarmModel):
                    self.alarmData.append(alarmModel)
                    self.tableViewLoad()
                    requestButton.setTitle("채팅요청 \(requestData[0].content.count)", for: .normal)
                case .failure(let error):
                    print("AlarmDeleteError: \(error)")
                }
            }
    }
    //테이블뷰 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

