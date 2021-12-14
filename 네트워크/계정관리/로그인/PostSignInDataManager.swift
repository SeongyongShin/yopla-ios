//
//  PostLoginDataManager.swift
//  yopla
//
//  Created by 신성용 on 2021/11/04.
//
import Foundation
import Alamofire

class PostSignInDataManager {
    
    // 로그인
    func postSignIn(_ parameters: PostSignInRequest, delegate: LoginVC) {
        
        AF.request("\(Constant.BASE_URL)/app/users/logIn", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: PostSignInResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    print(response)
                    if response.isSuccess{
                        delegate.didSuccessSignIn(result: response.result)
                    }
                    // 실패했을 때
                    else {
                        delegate.failedToRequest(message: "\(response.message )")
                    }
                case .failure(let error):
                    delegate.failedToRequest(message: "아이디 또는 비밀번호가 올바르지 않거나 서버가 원할하지 않습니다.")
                    print(error.localizedDescription)
                }
            }
    }
    
}
