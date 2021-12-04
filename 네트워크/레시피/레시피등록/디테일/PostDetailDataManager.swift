//
//  PostDetailDataManager.swift
//  yopla
//
//  Created by 신성용 on 2021/11/15.
//

import Foundation
import Alamofire

class PostDetailDataManager{
    
    // 내용 등록
    func postThumbNail(_ parameters: PostDetailRequest, delegate: RegistRecipeDetailVC) {
        
        AF.request("\(Constant.BASE_URL)/app/users/recipes/\(parameters.recipeId)", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: ["x-access-token": Constant.JWT_TOKEN!])
            .validate()
            .responseDecodable(of: PostDetailResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    print(response)
                    if response.isSuccess!{
                        delegate.didSuccessPostDetail(result: response.result ?? "asd")
                    }
                    // 실패했을 때
                    else {
                        print(response)
                        switch response.code {
                        case 2000: delegate.failedToRequest(message: "문제~")
                        case 3000: delegate.failedToRequest(message: "문제")
                        case 4000: delegate.failedToRequest(message: "서버 업로드에 문제가 발생했습니다.")
                        default: delegate.failedToRequest(message: "문제 발생")
                        }
                    }
                case .failure(let error):
                    print(response)
                    print(error.localizedDescription)
                }
            }
    }
    // 내용 수정
    func patchThumbNail(_ parameters: PostDetailRequest, delegate: RegistRecipeDetailVC) {
        
        AF.request("\(Constant.BASE_URL)/app/users/recipes/patchDetails", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: ["x-access-token": Constant.JWT_TOKEN!])
            .validate()
            .responseDecodable(of: PostDetailResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    print(response)
                    if response.isSuccess!{
                        delegate.didSuccessPostDetail(result: response.result ?? "asd")
                    }
                    // 실패했을 때
                    else {
                        print(response)
                        switch response.code {
                        case 2000: delegate.failedToRequest(message: "문제~")
                        case 3000: delegate.failedToRequest(message: "문제")
                        case 4000: delegate.failedToRequest(message: "서버 업로드에 문제가 발생했습니다.")
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
