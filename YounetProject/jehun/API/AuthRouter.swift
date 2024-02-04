//
//  Auth.swift
//  YounetProject
//
//  Created by 김제훈 on 2/4/24.
//

import Foundation
import Alamofire

let BASE_URL = "www.naver.com"

enum AuthRouter : URLRequestConvertible {
    
    // 회원가입 - 이메일 인증 코드 전송
    // /user/signup/email
    case sendEmailAuthCode(email: String)
    
    // 회원가입 - 이메일 인증번호 확인
    // /user/email/verification
    case checkEmailAuthCode(userEmail: String, code: String)
    
    
    var baseURL: URL {
        return URL(string: BASE_URL + "/user")!
    }
    
    var method: HTTPMethod {
        switch self {
        default:                                
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .sendEmailAuthCode:
            return "/signup/email"
        case .checkEmailAuthCode:
            return "/email/verification"
        }
    }
    
    // www.google.com/q=
    var queryParams: Parameters {
        switch self {
//        case .toggleATodoIsDone(let id, _),
//                .updateATodo(let id, _):
//            return ["id" : "eq.\(id)"]
//        case .deleteATodo(let id), .fetchATodo(let id): return ["id" : "eq.\(id)"]
//        case .fetchTodos:                               return ["select" : "*"]
        default: return Parameters()
        }
    }
    
    var bodyParams: Parameters {
        switch self {
        case .sendEmailAuthCode(let email):
            return ["email" : email]
        case let .checkEmailAuthCode(userEmail, code):
            return ["userEmail" : userEmail,
                    "code" : code]
        default: return Parameters()
        }
    }
    
    var headers : HTTPHeaders {
        
        var defaultHeaders = HTTPHeaders([
//            HTTPHeader(name: "apikey", value: ),
//            HTTPHeader(name: "Authorization", value: "Bearer \()")
        ])
        
        switch self {
//        case .toggleATodoIsDone, .addATodo, .updateATodo:
//            defaultHeaders.add(name: "Content-Type", value: "application/json")
//            defaultHeaders.add(name: "Prefer", value: "return=minimal")
//            return defaultHeaders
        default:
            return defaultHeaders
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        
        request.headers = headers
        
        switch method {
//        case .get, .delete:
//            // baseURL?select=*
//            request = try URLEncoding.default.encode(request, with: queryParams)
//        case .patch:
//            request = try URLEncoding(destination: .queryString).encode(request, with: queryParams)
//            request.httpBody = try JSONEncoding.default.encode(request, with: bodyParams).httpBody
        case .post:
            request.httpBody = try JSONEncoding.default.encode(request, with: bodyParams).httpBody
        default:
            print("default")
        }
        return request
    }
}
