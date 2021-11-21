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
    static var JWT_TOKEN: String? =  "eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWR4IjoyLCJpYXQiOjE2MzY5NjA0OTQsImV4cCI6MTYzODQzMTcyMn0.zJ5EvBTWV_RTsfb1o39JUzQwg0tcWRj3a85WBPQbz_A"
    static var USER_IDX = 2
    static var CURRENT_RECIPE = 0
}
