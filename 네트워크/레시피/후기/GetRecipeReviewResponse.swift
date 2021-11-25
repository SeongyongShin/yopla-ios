//
//  GetRecipeReviewResponse.swift
//  yopla
//
//  Created by 신성용 on 2021/11/24.
//

import Foundation
struct GetRecipeReviewResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result : [GetRecipeReviewResult]?
}

struct GetRecipeReviewResult: Decodable{
    var reviewsIdx: Int
    var userNickName: String
    var userPI: String?
    var content: String
    var reviewScore: Int
    var createdAt: String
    var recipeName: String?
}
