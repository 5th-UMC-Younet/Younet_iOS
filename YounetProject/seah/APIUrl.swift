//
//  APIUrl.swift
//  YounetProject
//
//  Created by 김세아 on 2/11/24.
//

import Foundation

struct APIUrl {
    static let url = "http://3.34.112.205:8080"

    static let login = url + "/user/login"
    static let findId = url + "/user/findId"
    static let findPwSendEmail = url + "/user/findPassword/email?loginId="
    static let findPwVerify = url + "/user/findPassword/email/verification"
    static let resetPw = url + "/user/resetPassword"
    
    static let logout = url + "/user/logout"
    static let withDrawal = url + "/user/withdrawl"
    
    static let kakaoLogin = url + "/oauth2/kakao?code="
    static let kakaoLogout = url + "/kakao/logout"
    
    static let myPage = url + "/mypage/info"
    static let otherUserPage = url + "/user/profile/"
    static let myPageEdit = url + "/mypage/edit"
    
    static let reIssue = url + "/auth/reissue"
    
    static let report = url + "/chat/report/"
    static let realNamePage = url + "/chat"
}

// MARK: - NetworkResult
enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}
