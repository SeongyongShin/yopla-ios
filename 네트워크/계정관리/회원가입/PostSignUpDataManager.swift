//
//  PostSignInDataManager.swift
//  yopla
//
//  Created by 신성용 on 2021/11/04.
//
import Foundation
import Alamofire

class PostSignUpDataManager{
    // 회원가입
    func postSignUp(_ parameters: PostSignUpRequest, delegate: RegistVC){
        AF.request("\(Constant.BASE_URL)/app/users/sign-up", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: PostSignUpResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    print(response)
                    if response.isSuccess{
                        delegate.didSuccessSignUp(result: response.result)
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
                    print(response)
                    print(error.localizedDescription)
                }
            
    }
    }
    
}
