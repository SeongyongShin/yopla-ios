//
//  PostDeleteRecipeResponse.swift
//  yopla
//
//  Created by 신성용 on 2021/11/28.
//

import Foundation

struct PostDeleteRecipeResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result : String?
}
