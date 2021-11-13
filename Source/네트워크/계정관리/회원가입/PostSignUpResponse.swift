//
//  PostSignInResponse.swift
//  yopla
//
//  Created by 신성용 on 2021/11/04.
//

struct PostSignUpResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result : PostSignUpResult
}

struct PostSignUpResult: Decodable{
    var successed: String
}
