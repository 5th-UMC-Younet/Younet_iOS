//
//  ChatProfileDataModel.swift
//  YounetProject
//
//  Created by 김세아 on 2/15/24.
//

import Foundation
import Foundation

struct ChatProfileResponse<T: Codable>: Codable {
    var success: Bool
    var message: String
    var result: T?
    
    init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            success = (try? values.decode(Bool.self, forKey: .success)) ?? false
            message = (try? values.decode(String.self, forKey: .message)) ?? ""
            result = (try? values.decode(T.self, forKey: .result)) ?? nil
        }
}


// MARK: - 오픈채팅 타 유저 프로필 상세
struct ChatOtherUserProfileData: Codable, Equatable {
    static func == (lhs: ChatOtherUserProfileData, rhs: ChatOtherUserProfileData) -> Bool {
        lhs.userId == rhs.userId
    }
    
    var posts: [PostData]
    var userId : Int?
    var profilePicture : String?
    var name, likeCntr, profileText : String?
}


// MARK: - 오픈채팅방 유저 개별 프로필 조회
struct ChatProfileData: Codable {
    var posts: [PostData]
    var userId, communityProfileId : Int?
    var profilePicture, name, likeCntr, profileText : String?
}

// MARK: - 오픈채팅 실명프로필 조회
struct RealNameProfileData: Codable {
    var userId: Int?
    var name, profilePicture, mainSkl, hostContr, hostSkl, profileText: String?
}
