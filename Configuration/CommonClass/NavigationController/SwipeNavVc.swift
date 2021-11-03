//
//  SwipeNavVc.swift
//  yopla
//
//  Created by 신성용 on 2021/10/31.
//

import UIKit

class SwipeNavVc: UINavigationController {

}


extension SwipeNavVc: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
