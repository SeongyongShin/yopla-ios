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
        print(parameters)
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(parameters.loginID!.utf8), withName: "loginId")
            multipartFormData.append(Data(parameters.password!.utf8), withName: "password")
            multipartFormData.append(Data(parameters.nickname!.utf8), withName: "nickname")
            multipartFormData.append(Data(parameters.email!.utf8), withName: "email")
            multipartFormData.append(Data(parameters.phoneNumber!.utf8), withName: "phoneNumber")
            multipartFormData.append(parameters.profileImage!, withName: "profileImage",fileName: "profile.jpg", mimeType: "image/jpg")

        }, to: "\(Constant.BASE_URL)/app/users/sign-up/withPI")
            .validate()
            .responseDecodable(of: PostSignUpResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print(response)
                    // 성공했을 때
                    if response.isSuccess{
                        delegate.didSuccessSignUp(result: response.result)
                    }
                    // 실패했을 때
                    else {
                        switch response.code {
                        case 2000: delegate.failedToRequest(message: "문제~")
                        case 3000: delegate.failedToRequest(message: "문제")
                        case 4000: delegate.failedToRequest(message: "적절한 요청이 아닙니다")
                        default: delegate.failedToRequest(message: "문제 발생")
                        }
                    }
                case .failure(let error):
                    print(response)
                    print(error)
                    print(error.localizedDescription)
                }
            }

    }
    
}
