//
//  BackGroundLineView.swift
//  yopla
//
//  Created by 신성용 on 2021/11/02.
//

import UIKit

class BackGroundLineView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .shadowGray
    }
}
class BackGroundShadowLineView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.backgroundColor = .shadowGray
        self.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        self.layer.shadowOffset = CGSize(width: 0, height: 1) // 위치조정
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 1 // 반경
        self.layer.shadowOpacity = 0.5 // alpha값
        self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
}
class SearchLineView: UIView{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .mainHotPink
        self.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        self.layer.shadowOffset = CGSize(width: 0, height: -5) // 위치조정
        self.layer.shadowColor = UIColor.mainHotPink.cgColor
        self.layer.shadowRadius = 5 // 반경
        self.layer.shadowOpacity = 1 // alpha값
        self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
}
