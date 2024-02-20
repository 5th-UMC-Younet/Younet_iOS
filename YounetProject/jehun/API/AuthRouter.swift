//
//  Auth.swift
//  YounetProject
//
//  Created by 김제훈 on 2/4/24.
//

import Foundation
import Alamofire
import UIKit

// http://3.34.112.205:8080
let BASE_URL = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080"

enum AuthRouter : URLRequestConvertible {
    
    // 회원가입
    // 이메일 인증 코드 전송
    // /user/signup/email?email=이메일
    case sendEmailAuthCode(email: String)
    
    // 인증번호 확인
    // /user/signup/email/verification
    case checkEmailAuthCode(userEmail: String, code: String)
    
    // 일반회원가입
    // /user/signup
    case sendSignupInfo(name: String, nickname: String, userId: String, email: String, password: String)
    
    // 커뮤니티 오픈채팅방 선택
    // 본인인증 여부 확인 1
    // /profile/auth
    case checkIdentificationStatus
    
    // 본인인증
    // 본인인증 1
    // /profile/auth
    // 이미지 파일은 어떻게 추가하는가? - file: 이미지파일
    case sendIdentificationInfo(mainSchool: String, hostCountry: String, hostSchool: String)
    
    // 1:1채팅 1
    // 1:1 채팅 목록 조회
    // /chat/list
    case fetchChatList
    
    // 1:1 채팅 (개별 채팅방) 모든 메시지 불러오기
    // /chat/{chat_room_id}/message
    case fetchChatContent
    
    // 오픈채팅
    
    
    
    var baseURL: URL {
        switch self {
        case .sendEmailAuthCode, .checkEmailAuthCode, .sendSignupInfo:
            return URL(string: BASE_URL + "/user")!
        case .checkIdentificationStatus, .sendIdentificationInfo:
            return URL(string: BASE_URL + "/profile")!
        case .fetchChatList, .fetchChatContent:
            return URL(string: BASE_URL + "/chat")!
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .checkIdentificationStatus, .fetchChatList, .fetchChatContent:
            return .get
        default:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .sendEmailAuthCode:
            return "/signup/email"
        case .checkEmailAuthCode:
            return "/signup/email/verification"
        case .sendSignupInfo:
            return "/signup"
        case .checkIdentificationStatus,.sendIdentificationInfo:
            return "/auth"
        case .fetchChatList:
            return "/list"
        case .fetchChatContent:
            return "/(chat_room_id)/message"
        }
    }
    
    var queryParams: Parameters {
        switch self {
        case let .sendEmailAuthCode(email):
            return ["email" : "\(email)"]
        default: return Parameters()
        }
    }
    
    var bodyParams: Parameters {
        switch self {
        case let .checkEmailAuthCode(userEmail, code):
            return ["userEmail" : userEmail,
                    "code" : code]
        case let .sendSignupInfo(name, nickname, userId, email, password):
            return ["name" : name,
                    "nickname" : nickname,
                    "userId" : userId,
                    "email" : email,
                    "password" : password]
        case let .sendIdentificationInfo(mainSchool, hostCountry, hostSchool):
            return ["mainSchool" : mainSchool,
                    "hostCountry" : hostCountry,
                    "hostSchool" : hostSchool] // 이미지 추가
        default: return Parameters()
        }
    }
    
    var headers : HTTPHeaders {
        // Authorization : "Bearer ~" 이 있는 것도 있고 없는 것도 있다.
        var defaultHeaders = HTTPHeaders([
            HTTPHeader(name: "Authorization", value: UserDefaults.standard.accessToken)
        ])
        
        switch self {
        case .checkEmailAuthCode, .sendSignupInfo:
//        case .toggleATodoIsDone, .addATodo, .updateATodo:
            defaultHeaders.add(name: "Content-Type", value: "application/json")
            return defaultHeaders
        case .sendIdentificationInfo:
            defaultHeaders.add(name: "Content-Type", value: "multipart/form-data")
            return defaultHeaders
        
            
        default:
            return defaultHeaders
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        
        request.headers = headers
        
        switch self {
        case .sendEmailAuthCode:
            request = try URLEncoding.default.encode(request, with: queryParams)
        case .checkEmailAuthCode:
            request.httpBody = try JSONEncoding.default.encode(request, with: bodyParams).httpBody
        default:
            break
        }
        
//        switch method {
////        case .get, .delete:
////            // baseURL?select=*
////            request = try URLEncoding.default.encode(request, with: queryParams)
////        case .patch:
////            request = try URLEncoding(destination: .queryString).encode(request, with: queryParams)
////            request.httpBody = try JSONEncoding.default.encode(request, with: bodyParams).httpBody
//        case .post:
//            request.httpBody = try JSONEncoding.default.encode(request, with: bodyParams).httpBody
//        default:
//            print("default")
//        }
        return request
    }
}

extension UserDefaults {
    
    /// accessToken 가져오기
    var accessToken : String {
        return UserDefaults.standard.string(forKey: "ACCESS_TOKEN") ?? ""
    }
    
    /// accessToken 저장하기
    func storeAccessToken(newToken: String){
        UserDefaults.standard.setValue(newToken, forKey: "ACCESS_TOKEN")
    }
}
