//
//  MyPageService.swift
//  YounetProject
//
//  Created by 김세아 on 2/12/24.
//

import Foundation
import Alamofire
import UIKit

// MARK: - 마이페이지 API
struct MyPageService{
    static let shared = MyPageService()
    let tk = TokenUtils()
    
    func MyPage(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        
        let url = APIUrl.myPage
        let tokenHeader = tk.getAuthorizationHeader(serviceID: APIUrl.url)
        
        // 요청하기
        let dataRequest = AF.request(url,
                                     method: .get,
                                     parameters: nil,
                                     encoding: JSONEncoding.default,
                                     headers: tokenHeader)
        
        dataRequest.responseData {(response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.value else { return }
                // 응답 상태와 정보를 입력으로 하는 judgeSingInData 함수 실행
                completion(judgeSignInData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    // 상태에 따라 어떤 것을 출력해줄지 결정
    func judgeSignInData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(MyPageResponse<MyPageUserData>.self, from: data) else { return .pathErr }
        switch status {
        case 200:
            return .success(decodedData.result!)
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
}

// MARK: - 마이페이지 프로필 수정 API
struct MyPageProfileEditService{
    static let shared = MyPageProfileEditService()
    let tk = TokenUtils()
    
    func MyPageEdit(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        
        let url = APIUrl.myPageEdit
        let tokenHeader = tk.getAuthorizationHeader(serviceID: APIUrl.url)
        
        // 요청하기
        let dataRequest = AF.request(url,
                                     method: .get,
                                     parameters: nil,
                                     encoding: JSONEncoding.default,
                                     headers: tokenHeader)
        
        dataRequest.responseData {(response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.value else { return }
                // 응답 상태와 정보를 입력으로 하는 judgeSingInData 함수 실행
                completion(judgeSignInData(status: statusCode, data: data))
                
                
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    func MyPageEditPatch(profilePicture: UIImage, name: String, nickname: String, likeCntr: String, profileText: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        
        let url = APIUrl.myPageEdit
        
        let header: HTTPHeaders = [
            "Content-Type":"multipart/form-data",
            "Accept" : "application/json",
            "Authorization": "\(tk.read(APIUrl.url, account: "accessToken")!)"
        ]
        let body: [String: Any] = [
            "name": name,
            "nickname": nickname,
            "likeCntr": likeCntr,
            "profileText": profileText
        ]
        let sendText = "\(body)".trimmingCharacters(in: ["[","]"])
        let dataText = asString(jsonDictionary: body)
        
        typealias JSONDictionary = [String : Any]

        func asString(jsonDictionary: JSONDictionary) -> String {
          do {
            let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
            return String(data: data, encoding: String.Encoding.utf8) ?? ""
          } catch {
            return ""
          }
        }
        // 요청하기
        let dataRequest = AF.upload(multipartFormData: { multipartFormData in
            
            //multipartFormData.append(try! JSONSerialization.data(withJSONObject: dataText) ?? Data(), withName: "editMyPage", mimeType: "application/json")
            print(dataText)
            multipartFormData.append("{\(sendText)}".data(using: .utf8)!, withName: "editMypage", mimeType: "application/json")
            print("\(tk.read(APIUrl.url, account: "accessToken")!)")
            //print("{\(sendText)}")
            //for (key, value) in body {
              // multipartFormData.append("\(value)".data(using: .utf8)!, withName: key, mimeType: "text/plain") }
            
            if let image = profilePicture.jpegData(compressionQuality: 1){
                print("변환 성공")
                print("\(image)")
                multipartFormData.append(image, withName: "file", fileName: "changedProfileImage.jpeg", mimeType: "image/jpeg") }
                                     }, to: url,
                                    method: .patch,
                                    headers: header)
        
        dataRequest.response {(response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.value else { return }
                // 응답 상태와 정보를 입력으로 하는 judgeSingInData 함수 실행
                completion(judgeSignInData2(status: statusCode))
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(.networkFail)
            }
        }
    }
    
    // 상태에 따라 어떤 것을 출력해줄지 결정
    func judgeSignInData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(MyPageResponse<MyPageEditUserData>.self, from: data) else { return .pathErr }
        switch status {
        case 200:
            return .success(decodedData.result!)
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    func judgeSignInData2(status: Int) -> NetworkResult<Any> {
        switch status {
        case 200:
            return .success(print("전송 성공"))
        case 400..<500:
            return .requestErr(print("전송 실패: request error"))
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
}

// MARK: - 로그아웃 API
struct LogoutService{
    static let shared = LogoutService()
    let tk = TokenUtils()
    
    func Logout(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        
        let url = APIUrl.logout
        let tokenHeader = tk.getAuthorizationHeader(serviceID: APIUrl.url)

        // 요청하기
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: nil,
                                     encoding: JSONEncoding.default,
                                     headers: tokenHeader)
        
        dataRequest.responseData {(response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.value else { return }
                // 응답 상태와 정보를 입력으로 하는 judgeSingInData 함수 실행
                completion(judgeSignInData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    // 상태에 따라 어떤 것을 출력해줄지 결정
    func judgeSignInData(status: Int, data: Data) -> NetworkResult<Any> {
        switch status {
        case 200:
            return .success(print("로그아웃 성공"))
        case 400..<500:
            return .requestErr(print("로그아웃 실패"))
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}

// MARK: - 회원탈퇴 API
struct WithDrawalService{
    static let shared = WithDrawalService()
    let tk = TokenUtils()
    
    func WithDrawal(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        
        let url = APIUrl.withDrawal
        let tokenHeader = tk.getAuthorizationHeader(serviceID: APIUrl.url)

        // 요청하기
        let dataRequest = AF.request(url,
                                     method: .delete,
                                     parameters: nil,
                                     encoding: JSONEncoding.default,
                                     headers: tokenHeader)
        
        dataRequest.responseData {(response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.value else { return }
                // 응답 상태와 정보를 입력으로 하는 judgeSingInData 함수 실행
                completion(judgeSignInData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    // 상태에 따라 어떤 것을 출력해줄지 결정
    func judgeSignInData(status: Int, data: Data) -> NetworkResult<Any> {
        switch status {
        case 200:
            return .success(print("탈퇴 성공"))
        case 400..<500:
            return .requestErr(print("탈퇴 실패"))
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
