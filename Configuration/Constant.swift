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
    static var registThumbNail: PostThumbNailRequest?
    static var registDetail: [PostNewRecipe] = []
    static var registId: Int?
    static var viewFromDetail = false
}
