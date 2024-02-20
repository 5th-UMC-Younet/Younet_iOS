//
//  ChatProfileService.swift
//  YounetProject
//
//  Created by 김세아 on 2/15/24.
//

import Foundation
import Alamofire
import UIKit

// MARK: - 타 유저 프로필 조회 API
struct ChatOtherUserProfileService{
    static let shared = ChatOtherUserProfileService()
    let tk = TokenUtils()
    
    func OtherUserProfile(userId: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        
        let url = APIUrl.otherUserPage + "\(userId)"
        
        // 요청하기
        let dataRequest = AF.request(url,
                                     method: .get,
                                     encoding: JSONEncoding.default)
        
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
        guard let decodedData = try? decoder.decode(ChatProfileResponse<ChatOtherUserProfileData>.self, from: data) else { return .pathErr }
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

// MARK: - 실명 프로필 조회 API
struct RealNameProfileService{
    static let shared = RealNameProfileService()
    func RealNameProfile(userId: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        
        let url = APIUrl.realNamePage + "/\(userId)/realProfile"
        
        // 요청하기
        let dataRequest = AF.request(url,
                                     method: .get,
                                     encoding: JSONEncoding.default)
        
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
        guard let decodedData = try? decoder.decode(RealNameProfileData.self, from: data) else { return .pathErr }
        switch status {
        case 200:
            return .success(decodedData)
        case 400..<500:
            return .requestErr(decodedData)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
}

// MARK: - 오픈채팅 프로필 조회 API
struct OpenChatProfileService{
    static let shared = OpenChatProfileService()
    func OpenChatProfile(userId: Int, chatRoomId: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        
        let url = APIUrl.realNamePage + "\(chatRoomId)/\(userId)"
        
        // 요청하기
        let dataRequest = AF.request(url,
                                     method: .get,
                                     encoding: JSONEncoding.default)
        
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
        guard let decodedData = try? decoder.decode(ChatProfileResponse<ChatProfileData>.self, from: data) else { return .pathErr }
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


struct editRealNameProfileService{
    let tk = TokenUtils()
    
    func editRealNameProfileService(profilePicture: UIImage, profileText: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        
        let url = APIUrl.realNamePageEdit
        
        let header: HTTPHeaders = [
            "Content-Type":"multipart/form-data",
            "Authorization": "\(tk.read(APIUrl.url, account: "accessToken")!)"
        ]
        let body: [String: Any] = [
            "profileText": profileText
        ]
        let sendText = "\(body)".trimmingCharacters(in: ["[","]"])

        // 요청하기
        let dataRequest = AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append("{\(sendText)}".data(using: .utf8)!, withName: "editProfile", mimeType: "application/json")
            if let image = profilePicture.jpegData(compressionQuality: 0.5){
                multipartFormData.append(image, withName: "file", fileName: "changedProfileImage.jpeg", mimeType: "image/jpeg") }
                                     }, to: url,
                                    method: .patch,
                                    headers: header)
        
        dataRequest.response {(response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard response.value != nil else { return }
                // 응답 상태와 정보를 입력으로 하는 judgeSingInData 함수 실행
                completion(judgeSignInData(status: statusCode))
                
            case .failure(let err):
                print(err.localizedDescription)
                completion(.networkFail)
            }
        }
        
    }
    
    func judgeSignInData(status: Int) -> NetworkResult<Any> {
        switch status {
        case 200:
            return .success(print("실명프로필 수정 성공"))
        case 400..<500:
            return .requestErr(print("실명프로필 수정 실패: 400 ERROR"))
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
