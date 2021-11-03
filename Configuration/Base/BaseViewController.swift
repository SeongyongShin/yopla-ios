//
//  BaseViewController.swift
//  yopla
//
//  Created by 신성용 on 2021/10/30.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // 외부 터치 시 키보드내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    // MARK: UIWindow의 rootViewController를 변경하여 화면전환
    func changeRootViewController(_ viewControllerToPresent: UIViewController) {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = viewControllerToPresent
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        } else {
            viewControllerToPresent.modalPresentationStyle = .overFullScreen
            self.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
    
    func makeRootVC(_ storyboard: String){
        let mainTabBarController = UIStoryboard(name: "\(storyboard)", bundle: nil).instantiateViewController(identifier: "\(storyboard)")
        changeRootViewController(mainTabBarController)
    }
}
