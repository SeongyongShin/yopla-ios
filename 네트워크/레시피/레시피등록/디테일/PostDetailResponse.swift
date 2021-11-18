//
//  PostDetailResponse.swift
//  yopla
//
//  Created by 신성용 on 2021/11/15.
//

import Foundation

struct PostDetailResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result : String
}
