//
//  ModifyProfileRequest.swift
//  yopla
//
//  Created by 신성용 on 2021/12/02.
//

import Foundation

struct ModifyPI: Encodable{
    var userId: Int
    var newProfileImage: String
}
struct ModifyPW: Encodable{
    var userId: Int
    var userNickName: String
    var loginId: String
    var lastPassword: String
    var newPassword: String
    var email: String
    var address = ""
    
}
struct ModifyDelete: Encodable{
    var userId: Int
    var password: String
}
