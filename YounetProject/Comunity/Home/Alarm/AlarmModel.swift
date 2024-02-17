//
//  AlarmModel.swift
//  YounetProject
//
//  Created by 조혠 on 2/12/24.
//

import Foundation
struct AlarmModel: Codable {
    let content: [Alarm]?
    let size: Int?
    let number: Int?
    let first: Bool?
    let last: Bool?
    let numberOfElements: Int?
}

struct Alarm: Codable {
    let alarmId: Int?
    let alarmType: String?
    let postId: Int?
    let postTitle: String?
    let actorId: Int?
    let actorName: String?
    let createdAt: String?
}
//chatrequest
struct ChatRqModel: Codable {
    let content: [ChatAlarm]
    let size: Int
    let first: Bool
    let last: Bool
    let numberOfElements: Int
    let empty: Bool
}

struct ChatAlarm: Codable {
    let chatAlarmId: Int
    //let requesterId: Int
    let requesterName: String
    let createdAt: String
}
