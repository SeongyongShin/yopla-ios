//
//  GetRecipeReviewDataManager.swift
//  yopla
//
//  Created by 신성용 on 2021/11/24.
//

import Foundation
import Alamofire

class GetRecipeReviewDataManager{
    
    // 후기 가져오기
    func getRecipeReview(recipeId:Int, delegate: RecipeDetailReviewVC) {
        let urlString = "\(Constant.BASE_URL)/app/users/recipes/\(recipeId)/reviews"
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encoded){
            print(url)
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["x-access-token": Constant.JWT_TOKEN!])
                .validate()
                .responseDecodable(of: GetRecipeReviewResponse.self) { response in
                    switch response.result {
                    case .success(let response):
                        delegate.didSuccessGetReview(result: response.result)
                    case .failure(let error):
                        print(error)
                        delegate.failedToRequest(message: "요청 실패")
                    }
                }
        }

    }
    
    // 내 레시피 후기 가져오기
    func getMyRecipeReview(delegate: MyRecipeReviewVC) {
        let urlString = "\(Constant.BASE_URL)/app/users/\(Constant.USER_IDX)/myRecipeReviews"
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let url = URL(string: encoded){
            print(url)
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["x-access-token": Constant.JWT_TOKEN!])
                .validate()
                .responseDecodable(of: GetRecipeReviewResponse.self) { response in
                    switch response.result {
                    case .success(let response):
                        delegate.didSuccessGetReview(result: response.result)
                    case .failure(let error):
                        print(error)
                        delegate.failedToRequest(message: "요청 실패")
                    }
                }
        }

    }
}
