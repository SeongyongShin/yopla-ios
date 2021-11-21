//
//  GetRecipeDataManager.swift
//  yopla
//
//  Created by 신성용 on 2021/11/21.
//

import Foundation
import Alamofire

class GetRecipeDataManager{
    // 대중레시피 가져오기
    func getPeopleRecipe(delegate: MainVC) {
        let url = "\(Constant.BASE_URL)/app/users/\(Constant.USER_IDX)/pplsRecipes"

        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["x-access-token": Constant.JWT_TOKEN!])
            .validate()
            .responseDecodable(of: GetPeopleRecipeResponse.self) { response in
                switch response.result {
                case .success(let response):
//                    print(response)
                    delegate.didSuccessRequestPeopleRecipe(result: response)
                case .failure(let error):
                    print(error)
                    delegate.failedToRequest(message: "요청 실패")
                }
            }
    }
}
