//
//  BookMarkResponse.swift
//  yopla
//
//  Created by 신성용 on 2021/11/21.
//

import Foundation

struct BookMarkResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: String?
}
