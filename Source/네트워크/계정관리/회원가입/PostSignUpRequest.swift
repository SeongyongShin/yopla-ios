//
//  PostSignInRequest.swift
//  yopla
//
//  Created by 신성용 on 2021/11/04.
//
import UIKit

struct PostSignUpRequest :Encodable{
    var loginID: String?
    var password: String?
    var nickname: String?
    var email: String?
    var phoneNumber: String?
    var profileImage: Data?
}
