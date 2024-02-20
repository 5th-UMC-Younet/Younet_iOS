//
//  LoginService.swift
//  YounetProject
//
//  Created by 김세아 on 2/9/24.
//

import Foundation
import Alamofire

// MARK: - 로그인 API
struct LoginService{
    static let shared = LoginService()
    
    func signIn(id: String,
                password: String,
                completion: @escaping (NetworkResult<Any>) -> (Void)) {
        
        let url = APIUrl.login
        let header: HTTPHeaders = [
            "Content-Type":"application/json"
        ]
        let body: Parameters = [
            "userId": id,
            "password": password
        ]
        
        // 요청하기
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
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
        guard let decodedData = try? decoder.decode(LoginResponse<LoginUserData>.self, from: data) else { return .pathErr }
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


// MARK: - 비밀번호 찾기 인증번호 이메일 전송 API
struct SendEmailService{
    static let shared = SendEmailService()
    
    func sendEmail(id: String,
                completion: @escaping (NetworkResult<Any>) -> (Void)) {
        
        let url = APIUrl.findPwSendEmail + id
        let header: HTTPHeaders = [
            "Content-Type":"application/json"
        ]
        
        // 요청하기
        let dataRequest = AF.request(url,
                                     method: .post,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData {(response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.value else { return }
                // 응답 상태와 정보를 입력으로 하는 judgeSingInData 함수 실행
                completion(judgeSign(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    // 상태에 따라 어떤 것을 출력해줄지 결정
    private func judgeSign(status: Int, data: Data) -> NetworkResult<Any> {
        switch status {
        case 200:
            return .success(print("비밀번호 찾기 이메일 전송 성공"))
        case 400..<500:
            return .requestErr(print("비밀번호 찾기 이메일 전송 실패"))
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
}


// MARK: - 비밀번호 찾기 인증번호 검증 API
struct EmailVerificationService{
    static let shared = EmailVerificationService()
    
    func verifyEmail(id: String, code: String,
                completion: @escaping (NetworkResult<Any>) -> (Void)) {
        
        let url = APIUrl.findPwVerify
        let header: HTTPHeaders = [
            "Content-Type":"application/json"
        ]
        let body: Parameters = [
            "loginId": id,
            "code": code
        ]
        
        // 요청하기
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
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
    private func judgeSignInData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(LoginResponse<PwSearchUserData>.self, from: data) else { return .pathErr }
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


// MARK: - 비밀번호 재설정 API
struct PwResetService{
    static let shared = PwResetService()
    
    func resetPw(id: String, newPassword: String,
                completion: @escaping (NetworkResult<Any>) -> (Void)) {
        
        let url = APIUrl.resetPw
        let header: HTTPHeaders = [
            "Content-Type":"application/json"
        ]
        let body: Parameters = [
            "loginId": id,
            "newPassword": newPassword
        ]
        
        // 요청하기
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
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
    private func judgeSignInData(status: Int, data: Data) -> NetworkResult<Any> {
        switch status {
        case 200:
            return .success(print("비밀번호 재설정 완료"))
        case 400..<500:
            return .requestErr(print("비밀번호 재설정 실패"))
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}


// MARK: - ID 찾기 API
struct FindIdService{
    static let shared = FindIdService()
    
    func findId(name: String, email: String,
                completion: @escaping (NetworkResult<Any>) -> (Void)) {
        
        let url = APIUrl.findId
        let header: HTTPHeaders = [
            "Content-Type":"application/json"
        ]
        let body: Parameters = [
            "name": name,
            "email": email
        ]
        // 요청하기
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
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
    
    // 상태에 따라 어떤 것을 출력해줄지 결정 김세아
    private func judgeSignInData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(IdSearchUserData.self, from: data) else { return .pathErr }
        switch status {
        case 200:
            return .success(decodedData.result)
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}

// MARK: - 토큰 재발급 API
struct RefreshTokenService{
    static let shared = RefreshTokenService()
    
    func refreshToken(refreshToken: String,
                completion: @escaping (NetworkResult<Any>) -> (Void)) {
        
        let url = APIUrl.reIssue
        let header: HTTPHeaders = [
            "Content-Type":"application/json"
        ]
        let body: Parameters = [
            "refreshToken": refreshToken
        ]
        
        // 요청하기
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
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
        guard let decodedData = try? decoder.decode(LoginResponse<LoginUserData>.self, from: data) else { return .pathErr }
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
