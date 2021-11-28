//
//  Constant.swift
//  yopla
//
//  Created by 신성용 on 2021/10/30.
//

import Foundation
import UIKit

struct Constant{
    static let BASE_URL = "https://freeman-service.com"
    static let BASE_CORNER_RADIUS = CGFloat(5.0)
    static var keyboardHeight: CGFloat?
    static var videoUrls: [URL] = []
    static var tempThumbNails: ThumbPage?
    static var registThumbNail: PostThumbNailRequest?
    static var registDetail: [PostNewRecipe] = []
    static var registId: Int?
    static var viewFromDetail = false
    static var JWT_TOKEN: String? = "eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWR4IjoyOSwiaWF0IjoxNjM4MTIyMTkwLCJleHAiOjE2Mzk1OTM0MTl9.vCpkA-0po2QwPAIlqeGenBqe1zUipEdrlNxNzzxjkao"
    static var DID_SUCCESS_SIGN_UP = false
    static var USER_IDX = 29
    static var CURRENT_RECIPE = 0
    static var RECIPE_STAR = 4
    static var CURRENT_RECIPE_DETAIL: GetRecipeDetailResponse?
    static var IS_BOOKMARK_PAGE = false
    static var PEOPLE_RECIPE_LIST: GetPeopleRecipeResponse?
    static var PUBLIC_RECIPE_LIST: GetPeopleRecipeResponse?
    static var CURRENT_MORE_RECIPE_TYPE = 0
    static var CURRENT_RECIPE_TYPE = 0
}
