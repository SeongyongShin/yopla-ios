//
//  PostThumbNailRequest.swift
//  yopla
//
//  Created by 신성용 on 2021/11/15.
//

import Foundation
import UIKit

struct PostThumbNailRequest: Encodable{
    var userId: Int = 0
    var recipeName: String = "\(Int.random(in: 0...99999))test\(Int.random(in: 0...99999))"
    var category: String = "한식"
    var time: String = "20분 내외"
    var frontImageUrl: String = "hi"
    var tags: [String]?
}
