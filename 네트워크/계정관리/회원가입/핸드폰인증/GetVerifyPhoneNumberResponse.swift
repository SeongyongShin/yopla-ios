//
//  GetVerifyPhoneNumberResponse.swift
//  yopla
//
//  Created by 신성용 on 2021/11/08.
//

struct GetVerifyPhoneNumberResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result : Int
}

struct GetVerifyPhoneCodeResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result : String?
}
