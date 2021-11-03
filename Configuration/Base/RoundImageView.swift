//
//  RoundImageView.swift
//  yopla
//
//  Created by 신성용 on 2021/11/03.
//

import UIKit

class RoundImageView: UIImageView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = (self.frame.height / 2)
        self.clipsToBounds = true
    }
}
