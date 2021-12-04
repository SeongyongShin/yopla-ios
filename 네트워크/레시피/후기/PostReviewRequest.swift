//
//  PostReviewRequest.swift
//  yopla
//
//  Created by 신성용 on 2021/11/24.
//

import Foundation
import UIKit

struct PostReviewRequest: Encodable {
    var userId: Int
    var recipeId: Int
    var content: String
    var point : Int
    var type: String
}
