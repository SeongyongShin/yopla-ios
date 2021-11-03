//
//  RegistVC.swift
//  yopla
//
//  Created by 신성용 on 2021/10/31.
//

import UIKit

class RegistVC: BaseViewController {
    @IBOutlet weak var backSV: UIStackView!
    @IBOutlet weak var nextBtn: BaseButton!
    @IBOutlet weak var registScroll: UIScrollView!
    @IBOutlet weak var buttonSV: UIView!
    @IBOutlet weak var backLabel: BaseLabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailValidBtn: UIButton!
    var currentPage = 0
    var keyboardShow = false
    @IBOutlet weak var nextConstraint: NSLayoutConstraint!
    var currentKeyboardYPos: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 뷰에 리스너 추가
        addGestureRecognizer()
        
        //컴포넌트 설정 추가
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

// MARK: 텍스트필드 값 처리
extension RegistVC{
    @objc func textFieldDidChange(_ sender: Any?) {
     }
}

// MARK: 컴포넌트 설정
extension RegistVC{
    
    // 회원가입 페이지 스크롤
    func scrollPages(_ destination: CGFloat){
        UIView.animate(withDuration: 0.2, animations: {
            self.registScroll.contentOffset = CGPoint(x: self.view.frame.width * destination, y: 0)
        })
    }
    
    // 초기 버튼 리스너 추가
    func addGestureRecognizer(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(unwindToHome(sender:)))
        backSV.addGestureRecognizer(tapGesture)
        backSV.isUserInteractionEnabled = true
    }
    

    
    func setComponent(){
        nextBtn.backgroundColor = .mainHotPink
        self.emailTF.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
//        emailValidBtn.backgroundColor = .white
    }
}

// MARK: 키보드 움직임에 따른 뷰 조절부분
extension RegistVC{
    
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
        self.nextConstraint.constant = Constant.keyboardHeight! + 30
//        self.buttonSV.layoutIfNeeded()
        self.buttonSV.frame.origin.y -= Constant.keyboardHeight!
        currentKeyboardYPos = self.buttonSV.frame.origin.y
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
        self.nextConstraint.constant = 30
        self.buttonSV.frame.origin.y += Constant.keyboardHeight!
        currentKeyboardYPos = self.buttonSV.frame.origin.y
        keyboardShow = false
    }
}


// MARK: 클릭 이벤트
extension RegistVC{
    //다음버튼 클릭
    @IBAction func nextClick(_ sender: Any) {
        if currentPage < 2{
            scrollPages(CGFloat(currentPage + 1))
            currentPage += 1
            nextBtn.setTitle("다음", for: .normal)
            backLabel.text = "회원가입"
            if currentPage == 2{
                nextBtn.setTitle("완료", for: .normal)
            }
        }
    }
    
    // 메인으로 돌아가기, 뒤로가기
    @objc func unwindToHome(sender: Any){
        if currentPage == 0{
            self.performSegue(withIdentifier: "goHomeFromRegist", sender: self)
        }else{
            scrollPages(CGFloat(currentPage - 1))
            currentPage -= 1
            nextBtn.setTitle("다음", for: .normal)
            if currentPage == 0{
                backLabel.text = "홈"
            }
        }
        
    }
}
