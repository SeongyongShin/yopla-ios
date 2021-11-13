//
//  PostLoginRequest.swift
//  yopla
//
//  Created by 신성용 on 2021/11/04.
//

import Foundation
import UIKit

struct PostSignInRequest: Encodable{
    var loginId: String
    var password: String
}

