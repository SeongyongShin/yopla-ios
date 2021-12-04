//
//  UserResponse.swift
//  yopla
//
//  Created by 신성용 on 2021/12/02.
//

import Foundation

struct GetUserInfoResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: GetUserInfoResult?
}

struct GetUserInfoResult: Decodable{
    var userId: Int
    var profileImage: String?
    var userNickName: String
    var loginId: String
    var rankPoints: Int
    var email: String
    var phoneNumber: String
    var address: String?
}
