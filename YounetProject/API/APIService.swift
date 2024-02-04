//
//  APIService.swift
//  YounetProject
//
//  Created by 김제훈 on 2/4/24.
//

import Alamofire

class APIService {
    static let shared: APIService = APIService()
    
    //이메일 코드 전송
    //이메일 코드 받아오기
    
//    func requestEmailCode(email: String, completion: @escaping (String) -> Void){
//        AF.request(AuthRouter.sendEmailAuthCode(email: email))
//            .responseDecodable(of: [TodoEntity].self,
//                                           completionHandler: { response in
//            //                DataResponse<[TodoEntity], AFError>
//                            debugPrint(response)
//                            completion(response.value, response.error)
//                        })
//            .res
//            .responseDecodable(completionHandler: <#T##(DataResponse<Decodable, AFError>) -> Void#>)
//    }
}
