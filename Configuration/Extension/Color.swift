//
//  Color.swift
//  yopla
//
//  Created by 신성용 on 2021/10/30.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    class var invalidRed: UIColor{UIColor(red:252, green: 13, blue: 37)}
    class var gradient1: UIColor{UIColor(red:252, green: 176, blue: 142)}
    class var gradient2: UIColor{UIColor(red:252, green: 100, blue: 111)}
    class var buttonPink:UIColor{UIColor(red:253, green: 107, blue: 123)}
    class var mainHotPink: UIColor{UIColor(red:240, green: 117, blue: 114)}
    class var mainBackground: UIColor{UIColor(red:255, green: 242, blue: 239)}
    class var shadowGray: UIColor{UIColor(red:214, green: 214, blue: 214)}
    class var bronze: UIColor{UIColor(red:147, green: 93, blue: 64)}
    class var silver: UIColor{UIColor(red:179, green: 179, blue: 179)}
    class var gold: UIColor{UIColor(red:250, green: 173, blue: 49)}
    
}
