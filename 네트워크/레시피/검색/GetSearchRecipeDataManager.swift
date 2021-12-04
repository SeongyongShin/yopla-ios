//
//  GetSearchRecipeDataManager.swift
//  yopla
//
//  Created by 신성용 on 2021/11/21.
//

import Foundation
import Alamofire

class GetSearchRecipeDataManager{
    
    // 대중레시피 가져오기
    func getSerchRecipe(word: String, type:String, delegate: SearchRecipeVC) {
        let urlString = "\(Constant.BASE_URL)/app/users/\(Constant.USER_IDX!)/recipes/search?\(type)=\(word)"
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encoded){
            
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["x-access-token": Constant.JWT_TOKEN!])
                .validate()
                .responseDecodable(of: GetSearchRecipeResponse.self) { response in
                    switch response.result {
                    case .success(let response):
                        delegate.didSuccessSearch(result: response)
                    case .failure(let error):
                        print(error)
                        delegate.failedToRequest(message: "요청 실패")
                    }
                }
        }
    }
    
    // 카테고리별 레시피 가져오기
    func getCategoryRecipe(category: String, delegate: MainVC) {
        let urlString = "\(Constant.BASE_URL)/app/users/\(Constant.USER_IDX!)/category/\(category)"
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encoded){
            
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["x-access-token": Constant.JWT_TOKEN!])
                .validate()
                .responseDecodable(of: GetSearchRecipeResponse.self) { response in
                    switch response.result {
                    case .success(let response):
                        delegate.didSuccessCategory(result: response)
                    case .failure(let error):
                        print(error)
                        delegate.failedToRequest(message: "요청 실패")
                    }
                }
        }
    }
}
