//
//  ModifyCell.swift
//  yopla
//
//  Created by 신성용 on 2021/12/07.
//

import Foundation
import UIKit

struct ModifyST{
    var img: UIImage
    var type: String
    var filePath: String?
    
}
protocol ModifyCell{
    
    func modifyData(section: Int, item: Int)
    func getPhoto(section: Int, item: Int)
}
