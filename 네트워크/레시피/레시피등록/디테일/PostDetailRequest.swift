//
//  PostDetailRequest.swift
//  yopla
//
//  Created by 신성용 on 2021/11/15.
//

import Foundation
import UIKit

struct PostDetailRequest: Encodable{
    var recipeId: Int
    var newRecipeDetails: [PostNewRecipe]
}

struct PostNewRecipe: Encodable{
    var title: String
    var ingredients: String
    var contents: String
    var detailFileUrl: String
    var type: String
}
