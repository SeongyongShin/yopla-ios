//
//  RecipeDetailReviewVC.swift
//  yopla
//
//  Created by 신성용 on 2021/11/09.
//

import UIKit

class RecipeDetailReviewVC: BaseViewController{
    var keyboardHeight:CGFloat = 0
    var keyboardShow = false
    @IBOutlet weak var reviewContainerV: UIView!
    @IBOutlet weak var reviewPlaceHolder: UILabel!
    @IBOutlet weak var reviewTextV: UITextView!
    @IBOutlet weak var reviewTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
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

// MARK: 컴포넌트 설정
extension RecipeDetailReviewVC{
    func setComponent(){
        self.reviewContainerV.layer.cornerRadius = 7
        self.reviewContainerV.layer.borderWidth = 1
        self.reviewContainerV.layer.borderColor = UIColor.mainHotPink.cgColor
        self.reviewTextV.delegate = self
    }
}

//MARK: 터치이벤트
extension RecipeDetailReviewVC: UITextViewDelegate{
    // placeholder 추가/제거
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text! == ""{
            self.reviewPlaceHolder.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text! == ""{
            self.reviewPlaceHolder.text = "후기 작성하기(10자 이상)"
        }
    }
}

//MARK: 키보드만큼 올리기
extension RecipeDetailReviewVC{
    
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
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y -= self.keyboardHeight
            self.view.layoutIfNeeded()
            keyboardShow = true
        }
        

    }
    
    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillHide(_ noti: NSNotification){
        
        if !keyboardShow{
            //키보드가 떠있지 않으면
            return
        }
        self.view.frame.origin.y += self.keyboardHeight
        self.view.layoutIfNeeded()
        
        keyboardShow = false
    }
}
