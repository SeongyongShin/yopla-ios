//
//  GetMorePeopleRecipeDataManager.swift
//  yopla
//
//  Created by 신성용 on 2021/11/29.
//

import Foundation
import Alamofire

class GetMorePeopleRecipeDataManager{
    // 갓반인 레시피 리스트 가져오기
    func getPeopleRecipe(more_type: Int, delegate: MoreRecipeVC) {
        var str1 = "shortsForm"
        if more_type != 0{
            str1 = "hots"
        }
        let url = "\(Constant.BASE_URL)/app/users/\(Constant.USER_IDX!)/pplsRecipes/\(str1)"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["x-access-token": Constant.JWT_TOKEN!])
            .validate()
            .responseDecodable(of: GetMorePeopleRecipeResponse.self) { response in
                switch response.result {
                case .success(let response):
//                    print(response)
                    delegate.didSuccessRequestPeopleRecipe(result: response.result)
                case .failure(let error):
                    print(error)
                    delegate.failedToRequest(message: "요청 실패")
                }
            }
    }
    // 대중 레시피 리스트 가져오기
    func getPublicRecipe(more_type: Int, delegate: MoreRecipeVC) {
        var str1 = "recommends"
        if more_type == 1{
            str1 = "hots"
        }
        let url = "\(Constant.BASE_URL)/app/users/\(Constant.USER_IDX!)/publicRecipes/\(str1)"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["x-access-token": Constant.JWT_TOKEN!])
            .validate()
            .responseDecodable(of: GetMorePeopleRecipeResponse.self) { response in
                switch response.result {
                case .success(let response):
//                    print(response)
                    delegate.didSuccessRequestPeopleRecipe(result: response.result)
                case .failure(let error):
                    print(error)
                    delegate.failedToRequest(message: "요청 실패")
                }
            }
    }
}
