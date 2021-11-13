//
//  SegueFromRight.swift
//  yopla
//
//  Created by 신성용 on 2021/11/06.
//

import UIKit

class SegueFromRight: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination

        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)

        UIView.animate(withDuration: 0.25,
                              delay: 0.0,
                            options: .curveEaseInOut,
                         animations: {
                                src.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
                                dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
                                },
                        completion: { finished in
            src.dismiss(animated: false, completion: nil)
//                                src.present(dst, animated: false, completion: nil)
                                    }
                        )
    }
}
