//
//  PostLoginResponse.swift
//  yopla
//
//  Created by 신성용 on 2021/11/04.
//

import Foundation

struct PostSignInResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result : PostSignInResult
}

struct PostSignInResult: Decodable{
    var userIdx: Int?
    var jwt: String?
}
