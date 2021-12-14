//
//  GetDuplicationDataManager.swift
//  yopla
//
//  Created by 신성용 on 2021/11/07.
//

import Foundation
import Alamofire

class GetDuplicationDataManager{

    func duplicatedEmail(_ parameters: String, delegate: RegistVC) {

        let url = "\(Constant.BASE_URL)/app/users/sign-up/id-check?loginId=\(parameters)"

        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: GetDuplicationResponse.self) { response in
                switch response.result {
                case .success(let response):
                    if response.result == "Exist"{
                        delegate.didfailedEmail("이미 사용중인 이메일입니다.")
                    }else{
                        delegate.didSuccessEmail()
                    }
                case .failure(let error):
                    print(error)
                    delegate.didfailedEmail("요청 실패")
                }
            }
    }
    
    func duplicatedNickName(_ parameters: String, delegate: RegistVC) {
        let urlString = "\(Constant.BASE_URL)/app/users/sign-up/nickname?nickname=\(parameters)"
        
           if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encoded){

        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseDecodable(of: GetDuplicationResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print(response)
                    if response.result == "Exist"{
                        delegate.didfailedNickName()
                    }else{
                        delegate.didSuccessNickName()
                    }
                case .failure(let error):
                    print(response)
                    print(error)
                    delegate.failedToRequest(message: "요청에 실패하였습니다.")
                }
            }
    }
    }
}
