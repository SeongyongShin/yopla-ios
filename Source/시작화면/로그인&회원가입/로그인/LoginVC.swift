//
//  LoginVC.swift
//  yopla
//
//  Created by 신성용 on 2021/10/30.
//

import UIKit

class LoginVC: BaseViewController{
    
    @IBOutlet weak var backSV: UIStackView!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var loginBtn: BaseButton!
    @IBOutlet weak var findLabel: UILabel!
    @IBOutlet weak var buttonSV: UIStackView!
    @IBOutlet weak var findSV: UIStackView!
    @IBOutlet weak var nextConstraint: NSLayoutConstraint!
    var keyboardShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 뷰에 리스너 추가
        addGestureRecognizer()
        
        // 컴포넌트 설정 추가
        setComponent()

    }
    

    override func viewWillAppear(_ animated: Bool) {
        // 키보드리스너 추가
        self.addKeyboardNotifications()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        // 키보드리스너 추가
        self.removeKeyboardNotifications()
        
    }


}

// MARK: 일반적인 컴포넌트 설정
extension LoginVC{
    
    // 초기 버튼 리스너 추가
    func addGestureRecognizer(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(unwindToHome(sender:)))
        backSV.addGestureRecognizer(tapGesture)
        backSV.isUserInteractionEnabled = true
        
        // 아이디 비번 찾기 연동
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(findIdPass(sender:)))
        findSV.addGestureRecognizer(tapGesture2)
        findSV.isUserInteractionEnabled = true
    }
    
    //초기 컴포넌트 설정
    func setComponent(){
        loginBtn.backgroundColor = .mainHotPink
        findLabel.textColor = .mainHotPink
    }
    
    
    // 아이디비번찾기 눌렀을 때
    @objc func findIdPass(sender: Any){
        print("findIdPass")
        
    }
    
    // 메인으로 돌아가기
    @objc func unwindToHome(sender: Any){
        self.performSegue(withIdentifier: "goHomeFromLogin", sender: self)
    }
    
    @IBAction func logInPressed(_ sender: Any) {
        //메인화면 이동
        makeRootVC("Main")
    }

}

// MARK: 키보드 움직임에 따른 뷰 조절부분
extension LoginVC{
    
    // 노티피케이션을 추가하는 메서드
    func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

    
    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillShow(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 올려준다.
        if keyboardShow{
            // 이미 키보드가 떠있으면
            return
        }
        if Constant.keyboardHeight == nil{
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                Constant.keyboardHeight = keyboardRectangle.height
            }
        }
        nextConstraint.constant = Constant.keyboardHeight! + 30
        self.buttonSV.frame.origin.y -= Constant.keyboardHeight!
        keyboardShow = true
    }
    
    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillHide(_ noti: NSNotification){
        
        if !keyboardShow{
            //키보드가 떠있지 않으면
            return
        }
        
        if Constant.keyboardHeight == nil{
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                Constant.keyboardHeight = keyboardRectangle.height
            }
        }
        
        nextConstraint.constant = 30
        self.buttonSV.frame.origin.y += Constant.keyboardHeight!
        keyboardShow = false
    }
}
