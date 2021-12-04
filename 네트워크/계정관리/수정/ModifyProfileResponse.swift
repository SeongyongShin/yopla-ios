//
//  ModifyProfileResponse.swift
//  yopla
//
//  Created by 신성용 on 2021/12/02.
//

import Foundation
struct ModifyProfileResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: String?
}
