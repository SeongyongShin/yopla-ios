//
//  PostDeleteRecipeDataManager.swift
//  yopla
//
//  Created by 신성용 on 2021/11/28.
//

import Foundation
import Alamofire

class PostDeleteRecipeDataManager{
    
    // 썸네일 등록
    func postDeleteRecipe(_ parameters: PostDeleteRecipeRequest, delegate: MyRegistedRecipeVC) {
        print(parameters)
        AF.request("\(Constant.BASE_URL)/app/users/recipes/status", method: .patch, parameters: parameters, encoder: JSONParameterEncoder(), headers: ["x-access-token": Constant.JWT_TOKEN!])
            .validate()
            .responseDecodable(of: PostDeleteRecipeResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    print(response)
                    if response.isSuccess{
                        delegate.didSuccessDeleteRecipe(result: response.result ?? "nil")
                    }
                    // 실패했을 때
                    else {
                        print(response)
                        switch response.code {
                        case 2000: delegate.failedToRequest(message: "문제~")
                        case 3000: delegate.failedToRequest(message: "문제")
                        case 4000: delegate.failedToRequest(message: "적절한 요청이 아닙니다")
                        default: delegate.failedToRequest(message: "문제 발생")
                        }
                    }
                case .failure(let error):
                    print(response)
                    print(error.localizedDescription)
                }
            }
    }
}
