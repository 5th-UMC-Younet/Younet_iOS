//
//  ChatProfileService.swift
//  YounetProject
//
//  Created by 김세아 on 2/15/24.
//

import Foundation
import Alamofire

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
// 지민이가 만든거 API 새로 추가
struct RealNameProfileService{
    static let shared = RealNameProfileService()
    let tk = TokenUtils()
    
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

// MARK: - 신고 API
struct ReportService{
    static let shared = ReportService()
    let tk = TokenUtils()
    
    func Report(userId: Int, reportReason: String, reportFile: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        
        let url = APIUrl.report + "\(userId)"
        let tokenheader = tk.getAuthorizationHeader(serviceID: APIUrl.url)
        
        let body: [String: Any] = [
            "reportReason": reportReason,
            "reportFile": reportFile
        ]
        
        // 요청하기
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: tokenheader)
        
        dataRequest.responseData {(response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.value else { return }
                completion(judgeSignInData(status: statusCode))
                
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    // 상태에 따라 어떤 것을 출력해줄지 결정
    func judgeSignInData(status: Int) -> NetworkResult<Any> {
        switch status {
        case 200:
            return .success(print("신고 성공"))
        case 400..<500:
            return .requestErr(print("신고 실패"))
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
}
