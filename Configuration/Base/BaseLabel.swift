//
//  BaseLabel.swift
//  yopla
//
//  Created by 신성용 on 2021/10/30.
//

import UIKit

class BaseLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    }
}
