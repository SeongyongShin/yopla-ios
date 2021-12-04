//
//  BookmarkDataManager.swift
//  yopla
//
//  Created by 신성용 on 2021/11/21.
//

import Foundation
import Alamofire

class BookmarkDataManager{
    //북마크 리스트
    func getBookMark(delegate: MyRegistedRecipeVC){
        let url = "\(Constant.BASE_URL)/app/users/\(Constant.USER_IDX!)/bookmarks"

        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: ["x-access-token": Constant.JWT_TOKEN!])
            .validate()
            .responseDecodable(of: GetBookMarkResponse.self) { response in
                switch response.result {
                case .success(let response):
                    delegate.didSuccessRequestBookMark(result: response.result)
                case .failure(let error):
                    print(error)
                    delegate.failedToRequest(message: "요청 실패")
                }
            }
    }
    // 북마크 등록
    func postBookMark(recipeId: Int, delegate: RecipeDetailStarVC) {
        var recipeType: String = "people"
        if Constant.CURRENT_RECIPE_TYPE == 0{
            recipeType = "public"
        }
        AF.request("\(Constant.BASE_URL)/app/users/recipes/bookmark", method: .post, parameters: BookMarkRequest(recipeId: recipeId, type: recipeType), encoder: JSONParameterEncoder(), headers: ["x-access-token": Constant.JWT_TOKEN!])
            .validate()
            .responseDecodable(of: BookMarkResponse.self) { response in
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
                        case 2027: self.patchBookMark(recipeId: recipeId, delegate: delegate, delegate2: nil)
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
    func patchBookMark(recipeId: Int, delegate: RecipeDetailStarVC?, delegate2: MyRegistedRecipeVC?) {
        
        var recipeType: String = "people"
        if Constant.CURRENT_RECIPE_TYPE == 0{
            recipeType = "public"
        }
        
        AF.request("\(Constant.BASE_URL)/app/users/recipes/bookmark/status", method: .patch, parameters: BookMarkRequest(recipeId: recipeId, type: recipeType), encoder: JSONParameterEncoder(), headers: ["x-access-token": Constant.JWT_TOKEN!])
            .validate()
            .responseDecodable(of: BookMarkResponse.self) { response in
                
                switch response.result {
                    
                case .success(let response):
                    // 성공했을 때
                    print(response)
                    if response.isSuccess{
                        if let delegate = delegate {
                            delegate.didSuccessBookMark(message: "북마크를 취소했습니다.")
                        }else{
                            delegate2!.didSuccessUnregistBookMark(message: "북마크를 취소했습니다.")
                        }
                    }
                    // 실패했을 때
                    else {
                        print(response)
                        if let delegate = delegate {
                            switch response.code {
                            case 2000: delegate.failedToRequest(message: "문제~")
                            case 3000: delegate.failedToRequest(message: "문제")
                            case 4000: delegate.failedToRequest(message: "적절한 요청이 아닙니다")
                            default: delegate.failedToRequest(message: "문제 발생")
                            }
                        }else{
                            switch response.code {
                            case 2000: delegate2!.failedToRequest(message: "문제~")
                            case 3000: delegate2!.failedToRequest(message: "문제")
                            case 4000: delegate2!.failedToRequest(message: "적절한 요청이 아닙니다")
                            default: delegate2!.failedToRequest(message: "문제 발생")
                            }
                        }

                    }
                case .failure(let error):
                    print(response)
                    print(error.localizedDescription)
                }
            }
    }
}


