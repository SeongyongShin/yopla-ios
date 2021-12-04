//
//  PostThumbNailRequest.swift
//  yopla
//
//  Created by 신성용 on 2021/11/15.
//

import Foundation
import UIKit

struct PostThumbNailRequest: Encodable{
    var userId: Int = Constant.USER_IDX!
    var recipeId: Int?
    var recipeName: String
    var category: String
    var time: String
    var frontImageUrl: String
    var tags: [String]?
}
