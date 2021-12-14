//
//  GetVerifyPhoneNumberDataManager.swift
//  yopla
//
//  Created by 신성용 on 2021/11/08.
//

import Foundation
import Alamofire

//class GetVerifyPhoneNumberDataManager{
//
//    // 인증번호 요청
//    func verifyPhoneNumber(_ parameters: String, delegate: RegistVC) {
//        let url = "\(Constant.BASE_URL)/app/users/sign-up/phoneVerify/sendSMS?phoneNumber=\(parameters)"
//
//        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
//            .validate()
//            .responseDecodable(of: GetVerifyPhoneNumberResponse.self) { response in
//                switch response.result {
//                case .success(let response):
//                    print(response)
//                    delegate.didSuccessRequestSMS(result: response.result)
//                case .failure(let error):
//                    print(error)
//                    delegate.failedToRequest(message: "요청 실패")
//                }
//            }
//    }
//    
//    // 인증번호 확인
//    func ConfirmPhoneCode(_ vnIdx: String, _ verifyNum: String, delegate: RegistVC) {
//        let url = "\(Constant.BASE_URL)/app/users/sign-up/phoneVerify/checkNum?vnIdx=\(vnIdx)&verifyNum=\(verifyNum)"
//
//        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
//            .validate()
//            .responseDecodable(of: GetVerifyPhoneCodeResponse.self) { response in
//                switch response.result {
//                case .success(let response):
//                    print(response)
//                    if response.code == 1000{
//                        delegate.didSuccessConfirmPhoneCode()
//                    }else{
//                        delegate.failedToRequest(message: "인증번호가 유효하지 않습니다.")
//                        delegate.didFailedConfirmPhoneCode()
//                    }
//                case .failure(let error):
//                    print(error)
//                    delegate.didFailedConfirmPhoneCode()
//                    delegate.failedToRequest(message: "요청 실패")
//                }
//            }
//    }
//}
