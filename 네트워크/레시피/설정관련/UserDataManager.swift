//
//  UserDataManager.swift
//  yopla
//
//  Created by 신성용 on 2021/12/02.
//

import Foundation
import Alamofire

class UserDataManager{
    func getMyProfile(delegate: MainVC) {
        let urlString = "\(Constant.BASE_URL)/app/users/\(Constant.USER_IDX!)/myInfo"
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encoded){
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["x-access-token": Constant.JWT_TOKEN!])
                .validate()
                .responseDecodable(of: GetUserInfoResponse.self) { response in
                    switch response.result {
                    case .success(let response):
                        delegate.didSuccessUserInfo(result: response)
                    case .failure(let error):
                        print(error)
                        delegate.failedToRequest(message: "요청 실패")
                    }
                }
        }

    }
}
