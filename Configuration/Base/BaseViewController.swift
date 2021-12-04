//
//  BaseViewController.swift
//  yopla
//
//  Created by 신성용 on 2021/10/30.
//

import UIKit

class BaseViewController: UIViewController {
    var dst: String?
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
    func makeTabBarRootVC(_ storyboard: String){
        let mainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "\(storyboard)")
        changeRootViewController(mainTabBarController)
    }
    func makeRootVC(_ storyboard: String, _ storyboard2: String){
        let mainViewController = UIStoryboard(name: "\(storyboard)", bundle: nil).instantiateViewController(identifier: "\(storyboard2)")
        print(mainViewController)
        changeRootViewController(mainViewController)
    }
    
    func swipeRecognizer(dst: String) {
        self.dst = dst
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction{
            case UISwipeGestureRecognizer.Direction.right:
                // 스와이프 시, 원하는 기능 구현.
                self.performSegue(withIdentifier: self.dst!, sender: self)
            default: break
            }
        }
    }
}
