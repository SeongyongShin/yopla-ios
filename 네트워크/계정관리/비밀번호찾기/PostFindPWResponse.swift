//
//  PostFindPWResponse.swift
//  yopla
//
//  Created by 신성용 on 2021/12/04.
//

import Foundation
struct PostFindPWResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result : String?
}
