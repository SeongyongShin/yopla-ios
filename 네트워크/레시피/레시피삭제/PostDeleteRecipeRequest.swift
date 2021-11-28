//
//  PostDeleteRecipeRequest.swift
//  yopla
//
//  Created by 신성용 on 2021/11/28.
//

import Foundation
import UIKit

struct PostDeleteRecipeRequest: Encodable{
    var userId: Int
    var recipeId: Int
}
