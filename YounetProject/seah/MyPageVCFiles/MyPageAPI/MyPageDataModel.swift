//
//  MyPageDataModel.swift
//  YounetProject
//
//  Created by 김세아 on 2/12/24.
//

import Foundation

struct MyPageResponse<T: Codable>: Codable {
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


// MARK: - MyPageUserData
struct MyPageUserData: Codable, Equatable {
    static func == (lhs: MyPageUserData, rhs: MyPageUserData) -> Bool {
        lhs.userId == rhs.userId
    }
    
    var posts: [PostData]
    var scraps: [ScrapData]
    var userId : Int?
    var profilePicture : String?
    var name, likeCntr, profileText : String?
}

struct PostData: Codable {
    var postId, categoryId : Int?
    var imageSampleUrl : String?
    var title, bodySample : String?
    var createdAt : String?
    var likesCount, commentsCount : Int?
}

struct ScrapData: Codable {
    var postId, categoryId : Int?
    var imageSampleUrl : String?
    var title, bodySample : String?
    var createdAt : String?
    var likesCount, commentsCount : Int?
}

// MARK: - MyPageUserData
struct MyPageEditUserData: Codable {
    var profilePicture, name, nickname, likeCntr, profileText : String?
}
