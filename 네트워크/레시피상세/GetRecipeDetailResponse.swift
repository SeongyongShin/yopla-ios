//
//  GetRecipeDetailResponse.swift
//  yopla
//
//  Created by 신성용 on 2021/11/24.
//

import Foundation

struct GetRecipeDetailResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result : GetRecipeDetailThumnails?
    var result2 : [GetRecipeDetail]?
}

struct GetRecipeDetailThumnails: Decodable{
    var recipeIdx: Int
    var title: String
    var recipeImage: String
    var userProfileImage: String?
    var userNickName: String
    var hits: Int
    var bookmarkCount: Int
    var bookmarked: Bool
    var times: String?
    var category: String?
    var tags: String?
}

struct GetRecipeDetail: Decodable{
    var recipeDetailsIdx: Int
    var title: String
    var ingredients: String
    var contents: String
    var detailFileUrl: String
    var fileType: String
    var modified: String?
}
