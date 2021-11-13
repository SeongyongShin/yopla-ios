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
                        delegate.didfailedEmail()
                    }else{
                        delegate.didSuccessEmail()
                    }
                case .failure(let error):
                    print(error)
                    delegate.didfailedEmail()
                }
            }
    }
    
}
