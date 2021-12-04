//
//  PostFindPWDataManager.swift
//  yopla
//
//  Created by 신성용 on 2021/12/04.
//

import Foundation
import Alamofire

class PostFindPWDataManager{
    // 회원가입
    func postFindPW(_ parameters: PostFindPWRequest, delegate: LoginVC){
        AF.request("\(Constant.BASE_URL)/app/users/findpassword", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: PostFindPWResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    print(response)
                    if response.isSuccess{
                        delegate.didSuccessSendEmail()
                    }
                    // 실패했을 때
                    else {
                        print(response)
                        switch response.code {
                        case 2000: delegate.failedToRequest(message: "문제~")
                        case 3000: delegate.failedToRequest(message: "문제")
                        case 3022: delegate.failedToRequest(message: "이메일과 전화번호가 일치하지 않거나 존재하지 않습니다.")
                        default: delegate.failedToRequest(message: "문제 발생")
                        }
                    }
                case .failure(let error):
                    delegate.failedToRequest(message: "임시 비밀번호 발급에 문제가 발생했습니다. 관리자에게 문의하세요.")
                    print(response)
                    print(error.localizedDescription)
                }
            
    }
    }
    
}
