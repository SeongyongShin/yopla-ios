//
//  BasrScrollView.swift
//  yopla
//
//  Created by 신성용 on 2021/11/01.
//

import UIKit

class BaseScrollView: UIScrollView {

    // 외부 터치 시 키보드내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.endEditing(true)
    }
}
