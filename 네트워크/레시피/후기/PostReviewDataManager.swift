//
//  PostReviewDataManager.swift
//  yopla
//
//  Created by 신성용 on 2021/11/24.
//

import Foundation
import Alamofire

class PostReviewDataManager{
    // 썸네일 등록
    func postREview(_ parameters: PostReviewRequest, delegate: RecipeDetailReviewVC) {
        
        AF.request("\(Constant.BASE_URL)/app/users/recipes/reviews", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: ["x-access-token": Constant.JWT_TOKEN!])
            .validate()
            .responseDecodable(of: PostReviewResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    print(response)
                    if response.isSuccess{
                        delegate.didSuccessPostReview(result: response.result)
                    }
                    // 실패했을 때
                    else {
                        print(response)
                        switch response.code {
                        case 2000: delegate.failedToRequest(message: "문제~")
                        case 3000: delegate.failedToRequest(message: "문제")
                        case 4000: delegate.failedToRequest(message: "이미 후기를 등록하였습니다.")
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
