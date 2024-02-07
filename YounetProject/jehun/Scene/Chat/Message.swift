//
//  Message.swift
//  YounetProject
//
//  Created by 김제훈 on 2/6/24.
//

import Foundation

/// for dummy
import Fakery

//{
//"messageId": Long,
//"userId": Long, - 보낸사람 userId
//"message": String,
//"createdAt": LocalDateTime,
//"read": boolean,
//"file": boolean
//},
//profile Img

class UserInfo {
    static let shared = UserInfo()
    
    var userId: Int64 = 123
}


/// message data
struct Message {
    //MARK: - original properties
    let messageId : Int64
    let userId : Int64
    let message: String
    let createdAt: Date
    let read: Bool
    let file: Bool
    
    //MARK: - added helper properties
    var profileImg: String = ""
    
    /// 메세지 전송 시간 문자열 ex) 15:04 PM
    var timestampString: String = ""
    
    /// 내 메세지 여부
    var isMyMessage : Bool {
        return self.userId == UserInfo.shared.userId
    }
    
    init(dictionary: [String: Any]){
        self.messageId = dictionary["messageId"] as? Int64 ?? 0
        self.userId = dictionary["userId"] as? Int64 ?? 0
        self.message = dictionary["message"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? Date ?? Date()
        self.read = dictionary["read"] as? Bool ?? false
        self.file = dictionary["file"] as? Bool ?? false
    }
    /// for dummy

}

//MARK: - Helpers - factory
extension Message {
    static func makeDummy() -> Message {
        
        let randomMsgId = (0...100).randomElement() ?? 0
        let randomUserId = (0...100).randomElement() ?? 0
        let randomMessageSentenceCount = (1...3).randomElement() ?? 0
        
        let userLocale = Locale.current.languageCode
        
        print(#fileID, #function, #line, "- userLocale: \(userLocale)")
        
//        let faker = Faker(locale: userLocale ?? "ko")
        let faker = Faker(locale:"ko")

        return Message(dictionary: [
            "messageId" : randomMsgId,
            "userId" : randomUserId,
            "message" : faker.lorem.sentences(amount: randomMessageSentenceCount),
            "createdAt" : Date(),
            "read": randomUserId % 2 == 1,
            "file": randomUserId % 2 == 1
        ])
    }
    
    static func makeDummies(count: Int = 30) -> [Message] {
        return (0...count).map{ _ in Message.makeDummy() }
    }
}

