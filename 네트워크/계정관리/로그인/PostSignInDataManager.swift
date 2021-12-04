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
                        print(response)
                        switch response.code {
                        case 2000: delegate.failedToRequest(message: "문제~")
                        case 3000: delegate.failedToRequest(message: "문제")
                        case 4000: delegate.failedToRequest(message: "적절한 요청이 아닙니다")
                        default: delegate.failedToRequest(message: "문제 발생")
                        }
                    }
                case .failure(let error):
                    delegate.failedToRequest(message: "로그인 실패, 아이디또는 비밀번호를 확인하세요.")
                    print(error.localizedDescription)
                }
            }
    }
    
}
