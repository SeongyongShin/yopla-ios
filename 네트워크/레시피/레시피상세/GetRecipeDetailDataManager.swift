//
//  GetRecipeDetailDataManager.swift
//  yopla
//
//  Created by 신성용 on 2021/11/24.
//

import Foundation
import Alamofire

class GetRecipeDetailDataManager{
    
    // 대중레시피 가져오기
    func getRecipeDetail(delegate: RecipeDetailVC) {
        let urlString = "\(Constant.BASE_URL)/app/users/\(Constant.USER_IDX)/recipes/\(Constant.CURRENT_RECIPE)"
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encoded){
            print(url)
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["x-access-token": Constant.JWT_TOKEN!])
                .validate()
                .responseDecodable(of: GetRecipeDetailResponse.self) { response in
                    switch response.result {
                    case .success(let response):
                        delegate.didSuccessDetail(result: response)
                    case .failure(let error):
                        print(error)
                        delegate.failedToRequest(message: "요청 실패")
                    }
                }
        }

    }
}

