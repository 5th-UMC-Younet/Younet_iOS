//
//  LoginDataModel.swift
//  YounetProject
//
//  Created by 김세아 on 2/8/24.
//
// response를 받을 객체

import Foundation

struct LoginResponse<T: Codable>: Codable {
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


// MARK: - UserData
struct LoginUserData: Codable {
    var accessToken, refreshToken : String
    var accessTokenExpiresIn : Int
}

struct PwSearchUserData: Codable {
    var loginId : String
}

struct IdSearchUserData: Codable {
    var message: String
    var result : String
}
