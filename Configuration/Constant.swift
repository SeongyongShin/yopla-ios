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
    static var DID_SUCCESS_SIGN_UP = false
    static var CURRENT_RECIPE = 0
    static var RECIPE_STAR = 4
    static var CURRENT_RECIPE_DETAIL: GetRecipeDetailResponse?
    static var TEMPORARY_DETAIL_VIDEO_THUMB: [UIImage] = []
    static var IS_BOOKMARK_PAGE = false
    static var PEOPLE_RECIPE_LIST: GetPeopleRecipeResponse?
    static var PUBLIC_RECIPE_LIST: GetPeopleRecipeResponse?
    static var CURRENT_MORE_RECIPE_TYPE = 0
    // 대중/갓반인 레시피 타입
    static var CURRENT_RECIPE_TYPE = 0
    static var IS_MODIFY_PAGE = false
    static var MY_PROFILE: GetUserInfoResult?
    // 카테고리에서 눌러서 들어왔는지
    static var IS_CATEGORY = false
    static var CURRENT_CATEGORY: String?
    static var CATEGORY_RESULT: [GetPeopleRecipeThumnails]?
    static var DID_LOG_OUT = false
    static var THUMBNAIL_PROGRESS = false
    
//    static var USER_IDX = 29
    static var USER_IDX: Int? = UserDefaults.standard.integer(forKey: "userIdx"){
        didSet {
            // UserDefault에 저장
            guard let user_id = USER_IDX else { return }
            print("user_id: \(user_id)")
            UserDefaults.standard.setValue(user_id, forKey: "userIdx")
        }
    }
    static var JWT_TOKEN: String? = UserDefaults.standard.string(forKey: "jwt") {
            didSet {
                // UserDefault에 저장
                guard let token = JWT_TOKEN else { return }
                print("TOKEN: \(token)")
                UserDefaults.standard.setValue(token, forKey: "jwt")
            }
        }
}
