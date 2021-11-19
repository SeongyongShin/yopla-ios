//
//  DetailPage.swift
//  yopla
//
//  Created by 신성용 on 2021/11/18.
//

import Foundation
import UIKit
struct DetailPage{
    var fileType: String?
    var title: String?
    var image: UIImage?
    var content: String?
    var ingredient: String?
    var videoURL: URL?
}
struct ThumbPage{
    var title: String?
    var tag: String?
    var image: UIImage?
    var category: String?
    var fileType: String?
}
struct TempDetailPage {
    var index: Int?
    var detail: PostNewRecipe
}
