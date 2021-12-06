//
//  ReportRequest.swift
//  yopla
//
//  Created by 신성용 on 2021/12/05.
//

import Foundation

struct ReportRequest: Encodable{
    var userId:Int =  Constant.USER_IDX!
    var targetId: Int
    var type: String
}
