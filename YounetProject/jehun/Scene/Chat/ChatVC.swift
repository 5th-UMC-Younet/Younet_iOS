//
//  ChatVC.swift
//  YounetProject
//
//  Created by 김제훈 on 2/6/24.
//

import UIKit
import Combine
import SwiftyJSON

class ChatVC: UIViewController {
    @IBOutlet var chatTableView: UITableView!
    
    var messageList: [Message] = []
    
    @IBOutlet var sendMsg: UIButton!
    @IBOutlet var userInputTextView: UITextView!
    
    var meMessageSendExampleEvent : PassthroughSubject<Message, Never> = PassthroughSubject()
    
    var messageReceivedExampleEvent : PassthroughSubject<Message, Never> = PassthroughSubject()
    
    var subscriptions : Set<AnyCancellable> = Set()
    
    var websocketTask : URLSessionWebSocketTask? = nil
    
    var isWSConnected : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let fetchedMessages = Message.makeDummies(count: 100)
//        dump(fetchedMessages)
//        messageList = fetchedMessages
        
        let myChatCellNib = UINib(nibName: "MyChatCell", bundle: .main)
        chatTableView.register(myChatCellNib, forCellReuseIdentifier: "MyChatCell")
        
        let yourChatCellNib = UINib(nibName: "YourChatCell", bundle: .main)
        chatTableView.register(yourChatCellNib, forCellReuseIdentifier: "YourChatCell")
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
//        chatTableView.reloadData()
            
        self.sendMsg.addTarget(self, action: #selector(sendChatMessage), for: .touchUpInside)
        
        self.meMessageSendExampleEvent
            .delay(for: 1, scheduler: DispatchQueue.main)
            .handleEvents(receiveOutput: { meMsg in
                self.messageReceivedExampleEvent.send(meMsg)
            })
            .delay(for: 1, scheduler: DispatchQueue.main)
            .sink(receiveValue: { meMsg in
                let newOtherMsg = Message.makeDummy()
                self.messageReceivedExampleEvent.send(newOtherMsg)
            }).store(in: &subscriptions)
        
        messageReceivedExampleEvent
            .sink(receiveValue: { newMsg in
                let lastIndex = self.messageList.count
                self.messageList.append(newMsg)
                let appendedIndexPath = IndexPath(row: lastIndex, section: 0)
                self.chatTableView.insertRows(at: [appendedIndexPath], with: .automatic)
                self.chatTableView.scrollToRow(at: appendedIndexPath, at: .bottom, animated: true)
            })
            .store(in: &subscriptions)
        
        connect()
    }
    
    @objc private func sendChatMessage(_ sender: UIButton){
        print(#fileID, #function, #line, "- ")
        // sent message
        
        let userInput = userInputTextView.text
        
        var sendMsg = Message(dictionary: [
            "userId" : UserInfo.shared.userId,
            "message" : userInput])
        
        self.meMessageSendExampleEvent.send(sendMsg)
    }
    
    
    fileprivate func disconnect(){
        print(#fileID, #function, #line, "- ")
        // 연결 끊기
        // https://developer.apple.com/documentation/foundation/urlsessionwebsockettask/3181200-cancel
        websocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    
    fileprivate func connect(){
        print(#fileID, #function, #line, "- ")
        
        disconnect()
        
        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: OperationQueue())
        
        guard let url = URL(string: "wss://ws-ap3.pusher.com:443/app/bd0b7360f2c92f6cff54") else { return }
        
        // https://developer.apple.com/documentation/foundation/urlsession/3181171-websockettask/
        websocketTask = session.webSocketTask(with: url)
        
        websocketTask?.resume()
        receiveMsg()
    }
    
    fileprivate func receiveMsg(){
        print(#fileID, #function, #line, "- ")
        websocketTask?.receive(completionHandler: { [weak self] (result :Result<URLSessionWebSocketTask.Message, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(.string(let msg)):
                print(#fileID, #function, #line, "- success(.string) msg: \(msg)")
                let decoder = JSONDecoder()
                if let responseDictionary = try? JSONSerialization.jsonObject(with: Data(msg.utf8), options: .mutableContainers) as? [String:AnyObject] {
                    let receivedMsg = responseDictionary["message"] as? String ?? ""
                    
                    var newMsg = Message(dictionary: [
                        "message" : receivedMsg])
                    DispatchQueue.main.async {
                        self.messageReceivedExampleEvent.send(newMsg)
                    }
                    
                }
                
                self.receiveMsg()
            case .success(.data(let msg)):
                print(#fileID, #function, #line, "- success(.data) msg: \(msg)")
            case .success(let msg):
                print(#fileID, #function, #line, "- success() msg: \(msg)")
            case .failure(let failure):
                print(#fileID, #function, #line, "- failure: \(failure)")
            }
        })
    }
    
    fileprivate func sendMessage(){
        print(#fileID, #function, #line, "- ")

        let dictionary = [
            "event" : "pusher:subscribe",
            "data" : [
                "channel": "public.room"
            ]
        ] as [String : Any]
        
        guard let jsonString = JSON(dictionary).rawString() else { return }
        
//        "{\"op\":\"price_sub\"}"
        let messageToSend = URLSessionWebSocketTask.Message.string(jsonString)
        
        self.websocketTask?.send(messageToSend, completionHandler: { err in
            print(#fileID, #function, #line, "- err: \(String(describing: err))")
//            if err == nil {
//                self.isWSConnected = true
//            } else {
//                self.isWSConnected = false
//            }
        })
    }
    
//    {
//        "event": "pusher:subscribe",
//        "data": {
//            "channel": "public.room"
//        }
//    }
    
}

extension ChatVC: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = messageList[indexPath.row]
        
        if cellData.isMyMessage {
            if let myChatCell = tableView.dequeueReusableCell(withIdentifier: "MyChatCell", for: indexPath) as? MyChatCell {
                myChatCell.updateUI(data: cellData)
                return myChatCell
            }
        }
        else {
            if let yourChatCell = tableView.dequeueReusableCell(withIdentifier: "YourChatCell", for: indexPath) as? YourChatCell {
                yourChatCell.updateUI(data: cellData)
                return yourChatCell
            }
        }
        
        
        
        return UITableViewCell()
    }
    
    
}
extension ChatVC: UITableViewDelegate
{
    
}

extension ChatVC : URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print(#fileID, #function, #line, "- 연결됨 , session: \(session)")
        sendMessage()
    }

    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print(#fileID, #function, #line, "- 끊김 , session: \(session), closeCode: \(closeCode), reason: \(reason)")
    }
}
