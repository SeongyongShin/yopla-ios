//
//  SwipeProtocol.swift
//  yopla
//
//  Created by 신성용 on 2022/03/08.
//

import Foundation
import UIKit

@objc protocol SwipeProtocol{
    
    @objc optional func directionToRight()
    @objc optional func directionToLeft()
    @objc optional func directionToUp()
    @objc optional func directionToDown()
}
