//
//  GetRegistedRecipeDataManager.swift
//  yopla
//
//  Created by 신성용 on 2021/11/25.
//

import Foundation
import Alamofire

class GetRegistedRecipeDataManager{
    func getRecipeList(delegate: MyRegistedRecipeVC) {
        let urlString = "\(Constant.BASE_URL)/app/users/\(Constant.USER_IDX)/recipes"
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encoded){
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["x-access-token": Constant.JWT_TOKEN!])
                .validate()
                .responseDecodable(of: GetRegistedRecipeResponse.self) { response in
                    switch response.result {
                    case .success(let response):
                        delegate.didSuccessRecipe(result: response)
                    case .failure(let error):
                        print(error)
                        delegate.failedToRequest(message: "요청 실패")
                    }
                }
        }

    }
}
