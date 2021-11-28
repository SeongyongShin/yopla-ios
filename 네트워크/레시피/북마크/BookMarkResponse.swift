//
//  BookMarkResponse.swift
//  yopla
//
//  Created by 신성용 on 2021/11/21.
//

import Foundation

struct BookMarkResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: String?
}

struct GetBookMarkResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: [GetBookMarkResult]?
}
struct GetBookMarkResult: Decodable{
    var bookmarksIdx: Int
    var recipeId: Int
    var recipeImage: String
    var recipeName: String
    var userNickName: String
    var category: String
    var bookmarkCount: Int
    var averageScore: Float
}
