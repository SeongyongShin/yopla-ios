//
//  bookMarkRequest.swift
//  yopla
//
//  Created by 신성용 on 2021/11/21.
//

import Foundation

struct BookMarkRequest: Encodable{
    var userId: Int = Constant.USER_IDX
    var recipeId: Int
}
