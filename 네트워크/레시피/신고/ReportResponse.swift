//
//  ReportResponse.swift
//  yopla
//
//  Created by 신성용 on 2021/12/05.
//

import Foundation

struct ReportResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
}
