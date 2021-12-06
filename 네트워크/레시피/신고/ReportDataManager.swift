//
//  ReportDataManager.swift
//  yopla
//
//  Created by 신성용 on 2021/12/05.
//

import Foundation
import Alamofire

class ReportDataManager{
    
    func postReport(_ parameters: ReportRequest, delegate: RecipeDetailStarVC) {
        AF.request("\(Constant.BASE_URL)/app/users/report", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: ["x-access-token": Constant.JWT_TOKEN!])
            .validate()
            .responseDecodable(of: ReportResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    print(response)
                    if response.isSuccess{
                        delegate.didSuccessReportRecipe()
                    }
                    // 실패했을 때
                    else {
                        print(response)
                        delegate.failedToRequest(message: response.message)
                    }
                case .failure(let error):
                    print(response)
                    print(error.localizedDescription)
                }
            }
    }
    
    func postReportReview(_ parameters: ReportRequest, delegate: RecipeDetailReviewVC) {
        AF.request("\(Constant.BASE_URL)/app/users/report", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: ["x-access-token": Constant.JWT_TOKEN!])
            .validate()
            .responseDecodable(of: ReportResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    print(response)
                    if response.isSuccess{
                        delegate.didSuccessReportRecipe()
                    }
                    // 실패했을 때
                    else {
                        print(response)
                        delegate.failedToRequest(message: response.message)
                    }
                case .failure(let error):
                    print(response)
                    print(error.localizedDescription)
                }
            }
    }
    func postReportReview2(_ parameters: ReportRequest, delegate: MyRecipeReviewVC) {
        AF.request("\(Constant.BASE_URL)/app/users/report", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: ["x-access-token": Constant.JWT_TOKEN!])
            .validate()
            .responseDecodable(of: ReportResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    print(response)
                    if response.isSuccess{
                        delegate.didSuccessReportRecipe()
                    }
                    // 실패했을 때
                    else {
                        print(response)
                        delegate.failedToRequest(message: response.message)
                    }
                case .failure(let error):
                    print(response)
                    print(error.localizedDescription)
                }
            }
    }
}
