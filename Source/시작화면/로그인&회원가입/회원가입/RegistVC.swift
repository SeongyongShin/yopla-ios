//
//  RegistVC.swift
//  yopla
//
//  Created by 신성용 on 2021/10/31.
//

import UIKit

class RegistVC: BaseViewController {
    var signUpRequest = PostSignUpRequest()
    
    var email_valid = false
    var phone_number_valid = false
    var phone_valid = false
    var nickName_valid = false
    var phoneCodeId: Int?
    var phoneCodeNum: Int?
    let imagePickerController = UIImagePickerController()
    @IBOutlet weak var profileImage: RoundImageView1!
    lazy var duplicationDataManager: GetDuplicationDataManager = GetDuplicationDataManager()
    lazy var verifyPhoneNumberDataManager: GetVerifyPhoneNumberDataManager = GetVerifyPhoneNumberDataManager()
    lazy var signUpDataManager: PostSignUpDataManager = PostSignUpDataManager()
    @IBOutlet weak var backSV: UIStackView!
    @IBOutlet weak var nextBtn: BaseButton!
    @IBOutlet weak var registScroll: UIScrollView!
    @IBOutlet weak var buttonSV: UIView!
    @IBOutlet weak var backLabel: BaseLabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordConfirmTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var phoneCodeTF: UITextField!
    @IBOutlet weak var nickNameTF: UITextField!
    
    @IBOutlet weak var emailValidBtn: RoundButton1!
    
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
    
    //이메일이 형식에 맞는지
    func isValidEmail(testStr:String) -> Bool {
          let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          return emailTest.evaluate(with: testStr)
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
//        self.pass.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
//        emailValidBtn.backgroundColor = .white
        imagePickerController.delegate = self
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.selectImageFromGallery)))
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
    //이메일 중복체크 클릭
    @IBAction func confirmEmailValid(_ sender: Any){
        if isValidEmail(testStr: self.emailTF.text ?? "none"){
            duplicationDataManager.duplicatedEmail(emailTF.text!, delegate: self)
        }else{
            self.presentBottomAlert(message: "이메일 형식을 확인해주세요")
        }
    }
    
    // 인증번호 발송 클릭
    @IBAction func verifyPhoneNumber(_ sender: Any){
        var phoneNum = self.phoneNumberTF.text ?? ""
        if phoneNum != ""{
            phoneNum = phoneNum.replacingOccurrences(of: " ", with: "")
            phoneNum = phoneNum.replacingOccurrences(of: "-", with: "")
        }else{
            self.presentBottomAlert(message: "휴대폰 번호가 유효하지 않습니다.")
            return
        }
        verifyPhoneNumberDataManager.verifyPhoneNumber(phoneNum, delegate: self)
    }
    // 인증번호 확인 클릭
    @IBAction func confirmVerifyPhoneNumber(_ sender: Any){
        if !phone_number_valid{
            self.presentBottomAlert(message: "핸드폰번호가 유효하지 않습니다.")
            return
        }
        let codeResponse = phoneCodeTF.text ?? ""
        if codeResponse != "" && phoneCodeId != nil{
            verifyPhoneNumberDataManager.ConfirmPhoneCode("\(phoneCodeId!)", "\(codeResponse)", delegate: self)
        }else{
            self.presentBottomAlert(message: "인증번호를 검증해주세요")
        }
    }
    //다음버튼 클릭
    @IBAction func nextClick(_ sender: Any) {
        if currentPage == 0{
            if !email_valid{
                self.presentBottomAlert(message: "이메일이 유효하지 않습니다.")
                return
            }
            if (passwordTF.text?.count ?? 0) < 8{
                self.presentBottomAlert(message: "비밀번호는 8자리 이상으로 입력해주세요")
                return
            }
            if (passwordTF.text != passwordConfirmTF.text) {
                self.presentBottomAlert(message: "비밀번호가 일치하지 않습니다.")
                return
            }
            self.signUpRequest.password = self.passwordTF.text
        }else if currentPage == 1{
            if !phone_number_valid{
                self.presentBottomAlert(message: "휴대폰 번호가 유효하지 않습니다.")
                return
            }
            if !phone_valid{
                self.presentBottomAlert(message: "인증번호가 유효하지 않습니다.")
                return
            }
        }else if currentPage == 2{
            signUpRequest.nickname = self.nickNameTF.text ?? "test\(Int.random(in: 0...9999))"
            signUpRequest.profileImage = self.profileImage.image!.jpegData(compressionQuality: 0.2)!
            if self.signUpRequest.phoneNumber != nil && self.signUpRequest.email != nil && self.signUpRequest.nickname != nil && self.signUpRequest.loginID != nil{
                self.signUpDataManager.postSignUp(signUpRequest, delegate: self)
            }
        }
        
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

// MARK: 회원가입 api 리턴
extension RegistVC{
    // 중복체크
    func didSuccessEmail(){
        self.emailValidBtn.backgroundColor = .green
        self.presentBottomAlert(message: "사용가능한 이메일입니다.")
        email_valid = true
        self.signUpRequest.email = self.emailTF.text
        self.signUpRequest.loginID = self.emailTF.text
    }
    func didfailedEmail(){
        self.emailValidBtn.backgroundColor = .white
        self.presentBottomAlert(message: "이미 사용중인 이메일입니다.")
        email_valid = false
        self.signUpRequest.email = nil
    }
    
    // 핸드폰인증
    func didSuccessRequestSMS(result: Int){
        phone_number_valid = true
        self.signUpRequest.phoneNumber = phoneNumberTF.text
        phoneCodeId = result
        self.presentBottomAlert(message: "인증번호 요청 성공")
    }
    // 인증코드 검증
    func didSuccessConfirmPhoneCode(){
        self.signUpRequest.phoneNumber = phoneNumberTF.text
        phone_valid = true
        self.presentBottomAlert(message: "인증성공")
    }
    func didFailedConfirmPhoneCode(){
        self.signUpRequest.phoneNumber = nil
    }
    
    
    // 회원가입 성공
    func didSuccessSignUp(result: PostSignUpResult){
        self.presentBottomAlert(message: "회원가입 성공")
    }
    // 회원가입 실패
    func failedToRequest(message: String){
        self.presentAlert(title: message)
    }
}

//MARK: 프로필 이미지 관련
extension RegistVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    // 갤러리에서 이미지 선택
    @objc func selectImageFromGallery(){
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    //선택한 이미지 등록
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.originalImage]{
            profileImage.image = (image as! UIImage)
        }
        dismiss(animated: true, completion: nil)
        
    }
}
