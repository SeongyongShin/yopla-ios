//
//  GetPeopleRecipeResponse.swift
//  yopla
//
//  Created by 신성용 on 2021/11/21.
//

import Foundation

struct GetPeopleRecipeResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result : [GetPeopleRecipeResult]
    var shorts: [GetPeopleRecipeThumnails]
    var hots: [GetPeopleRecipeThumnails]
    var recommend: [GetPeopleRecipeThumnails]
}

struct GetPeopleRecipeResult: Decodable{
    var adverIdx: Int
    var imagePath: String
}
struct GetMorePeopleRecipeResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: [GetPeopleRecipeThumnails]?
}
struct GetPeopleRecipeThumnails: Decodable{
    var recipeIdx: Int
    var title: String
    var recipeImage: String
    var userProfileImage: String?
    var userNickName: String
    var hits: Int
    var bookmarkCount: Int
    var bookmarked: Bool
    var averageScore: Float?
    var type: String?
}
