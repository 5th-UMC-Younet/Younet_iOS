//
//  APIService.swift
//  YounetProject
//
//  Created by 김제훈 on 2/4/24.
//

import Alamofire
import Foundation
import UIKit

class APIService {
    static let shared: APIService = APIService()
    
    // 이메일 코드 전송
    func requestEmailCode(email: String, completion: @escaping (String) -> Void) {
        AF.request(AuthRouter.sendEmailAuthCode(email: email))
            .validate()
            .response { res in
                debugPrint(res)
                guard let statusCode = res.response?.statusCode else {
                    return
                }
                if statusCode == 200 {
                    //                    if let data = res.data {
                    //                        let str = String(decoding: data, as: UTF8.self)
                    //                        completion(str)
                    //                        return
                    //                    }
                    completion("success")
                } else {
                    completion("fail")
                }
                
            }
    }
    
    // 인증번호 확인
    func confirmEmailCode(userEmail: String, code: String, completion: @escaping (String) -> Void) {
        AF.request(AuthRouter.checkEmailAuthCode(userEmail: userEmail, code: code))
            .validate()
            .response { res in
                debugPrint(res)
                guard let statusCode = res.response?.statusCode else {
                    return
                }
                if statusCode == 200 {
                    //                    if let data = res.data {
                    //                        let str = String(decoding: data, as: UTF8.self)
                    //                        completion(str)
                    //                        return
                    //                    }
                    completion("success")
                } else {
                    completion("fail")
                }
            }
    }
    
    // 일반 회원가입
    func signup(request : SignupRequest, completion: @escaping ([String: Any]) -> Void)
    {
        
        AF.request(AuthRouter.sendSignupInfo(name: request.name, nickname: request.nickname, userId: request.userId, email: request.email, password: request.password))
            .validate()
            .response { res in
                debugPrint(res)
                guard let statusCode = res.response?.statusCode else {
                    return
                }
                
                if let data = res.data, statusCode == 200 {
                    completion(data.toDictionary() ?? [:])
                    return
                }
                
            }
    }
    
    // 본인인증 여부 확인
    func checkIdentification(completion: @escaping (Bool) -> Void)
    {
        AF.request(AuthRouter.checkIdentificationStatus)
            .response { res in
                debugPrint(res)
                guard let statusCode = res.response?.statusCode else {
                    completion(false)
                    return
                }
                completion(statusCode == 200)
            }
    }
    
    // 본인인증
    func sendIdentificationInfo(registerInfo: RegisterInfo, completion: @escaping ([String:Any]) -> Void)
    {
        
        let url = "http://ec2-3-34-112-205.ap-northeast-2.compute.amazonaws.com:8080/profile/auth"
        
        let inputDictionary = ["mainSchool" : registerInfo.mainSchool, "hostCountry" : registerInfo.hostCountry, "hostSchool" : registerInfo.hostSchool]
        
        guard let jsonData : Data = try? JSONSerialization.data(withJSONObject: inputDictionary, options: .prettyPrinted),
              let imgData : Data = registerInfo.file.jpegData(compressionQuality: 100) else {
            return
        }
        
        // params -> dictionary
        //
        //

        let currentTime = Date().timeIntervalSince1970
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(jsonData, withName: "auth", mimeType: "application/json")
            multipartFormData.append(imgData, withName: "file", fileName: "\(currentTime).jpeg", mimeType: "image/jpeg")
        }, to: url)
        .uploadProgress { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
            }
        .response { res in
            debugPrint(res)
            guard let statusCode = res.response?.statusCode else {
                return
            }
            
            if let data = res.data, statusCode == 200 {
                completion(data.toDictionary() ?? [:])
                return
            }
            
        }
    }
    
    
}

extension Data {
    func toDictionary() -> [String: Any]? {
        return try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
    }
}


