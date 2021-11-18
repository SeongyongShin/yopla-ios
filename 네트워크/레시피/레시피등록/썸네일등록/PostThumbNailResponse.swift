//
//  PostThumbNailResponse.swift
//  yopla
//
//  Created by 신성용 on 2021/11/15.
//

import Foundation

struct PostThumbNailResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result : Int
}
