//
//  BookmarkDataManager.swift
//  yopla
//
//  Created by 신성용 on 2021/11/21.
//

import Foundation
import Alamofire

class BookmarkDataManager{
    // 북마크 등록
    func postBookMark(recipeId: Int, delegate: RecipeDetailStarVC) {
        
        AF.request("\(Constant.BASE_URL)/app/users/recipes/bookmark", method: .post, parameters: BookMarkRequest(recipeId: recipeId), encoder: JSONParameterEncoder(), headers: ["x-access-token": Constant.JWT_TOKEN!])
            .validate()
            .responseDecodable(of: BookMarkResponse.self) { response in
                
                print(BookMarkRequest(recipeId: recipeId))
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    if response.isSuccess{
                        print(response)
                        delegate.didSuccessBookMark(message: "북마크를 등록했습니다.")
                    }
                    // 실패했을 때
                    else {
                        print(response)
                        switch response.code {
                        case 2000: delegate.failedToRequest(message: "문제~")
                        case 2027: self.patchBookMark(recipeId: recipeId, delegate: delegate)
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
    // 북마크 해제
    func patchBookMark(recipeId: Int, delegate: RecipeDetailStarVC) {
        
        AF.request("\(Constant.BASE_URL)/app/users/recipes/bookmark/status", method: .patch, parameters: BookMarkRequest(recipeId: recipeId), encoder: JSONParameterEncoder(), headers: ["x-access-token": Constant.JWT_TOKEN!])
            .validate()
            .responseDecodable(of: BookMarkResponse.self) { response in
                
                switch response.result {
                    
                case .success(let response):
                    // 성공했을 때
                    print(response)
                    if response.isSuccess{
                        delegate.didSuccessBookMark(message: "북마크를 취소했습니다.")
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


