//
//  HalfRoundView1.swift
//  yopla
//
//  Created by 신성용 on 2021/11/03.
//
import UIKit

class HalfRoundView1: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.layer.shadowColor = UIColor.shadowGray.cgColor // 색깔
        self.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        self.layer.shadowOffset = CGSize(width: 0, height: -1) // 위치조정
        self.layer.shadowRadius = 1 // 반경
        self.layer.shadowOpacity = 1 // alpha값
        self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
}
