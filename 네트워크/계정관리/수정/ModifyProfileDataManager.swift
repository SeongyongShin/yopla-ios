//
//  ModifyProfileDataManager.swift
//  yopla
//
//  Created by 신성용 on 2021/12/02.
//

import Foundation
import Alamofire

class ModifyProfileDataManager {
    
    // 프로필이미지 수정
    func patchPI(_ parameters: ModifyPI, delegate: MyPageVC) {
        
        AF.request("\(Constant.BASE_URL)/app/users/myInfo/pi", method: .patch, parameters: parameters, encoder: JSONParameterEncoder(), headers: ["x-access-token": Constant.JWT_TOKEN!])
            .validate()
            .responseDecodable(of: ModifyProfileResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    print(response)
                    if response.isSuccess{
                        delegate.didSuccessPatchPI()
                    }
                    // 실패했을 때
                    else {
                        print(response)
                        switch response.code {
                        case 2000: delegate.failedToRequest(message: "문제가 발생했습니다.")
                        case 3000: delegate.failedToRequest(message: "문제가 발생했습니다.")
                        case 4000: delegate.failedToRequest(message: "적절한 요청이 아닙니다")
                        default: delegate.failedToRequest(message: "문제가 발생했습니다.")
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
 
    // 비밀번호 수정
    func patchPW(_ parameters: ModifyPW, delegate: MySettingVC) {
        
        AF.request("\(Constant.BASE_URL)/app/users/myInfo/status", method: .patch, parameters: parameters, encoder: JSONParameterEncoder(), headers: ["x-access-token": Constant.JWT_TOKEN!])
            .validate()
            .responseDecodable(of: ModifyProfileResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    print(response)
                    if response.isSuccess{
                        delegate.didSuccessPatchPW()
                    }
                    // 실패했을 때
                    else {
                        print(response)
                        switch response.code {
                        case 2000: delegate.failedToRequest(message: response.message)
                        case 3000: delegate.failedToRequest(message: response.message)
                        case 4000: delegate.failedToRequest(message: response.message)
                        default: delegate.failedToRequest(message: response.message)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    // 탈퇴
    func patchDetele(_ parameters: ModifyDelete, delegate: MySettingVC) {
        
        AF.request("\(Constant.BASE_URL)/app/users/secession", method: .patch, parameters: parameters, encoder: JSONParameterEncoder(), headers: ["x-access-token": Constant.JWT_TOKEN!])
            .validate()
            .responseDecodable(of: ModifyProfileResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    print(response)
                    if response.isSuccess{
                        delegate.didSuccessPatchPW()
                    }
                    // 실패했을 때
                    else {
                        print(response)
                        switch response.code {
                        case 2000: delegate.failedToRequest(message: response.message)
                        case 3000: delegate.failedToRequest(message: response.message)
                        case 4000: delegate.failedToRequest(message: response.message)
                        default: delegate.failedToRequest(message: response.message)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
