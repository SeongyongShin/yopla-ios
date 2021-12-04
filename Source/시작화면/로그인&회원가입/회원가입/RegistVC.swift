//
//  RegistVC.swift
//  yopla
//
//  Created by 신성용 on 2021/10/31.
//

import UIKit

class RegistVC: BaseViewController {
    var signUpRequest = PostSignUpRequest()
    var hasProfileImage = false
    var email_valid = false
    var phone_number_valid = false
    var phone_valid = false
    var nickName_valid = false
    var phoneCodeId: Int?
    var phoneCodeNum: Int?
    
    @IBOutlet weak var resultL: UILabel!
    let imagePickerController = UIImagePickerController()
    @IBOutlet weak var profileImage: RoundImageView1!
    lazy var AWSNetworkManager: AWSDataManager = AWSDataManager()
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
    @IBOutlet weak var emailValidUnderLine: UnderlineShadowView!
    @IBOutlet var passwordUnderLine: [UnderlineShadowView]!
    
    @IBOutlet weak var phoneValidBtn: RoundButton1!
    @IBOutlet weak var phoneCodeValidBtn: RoundButton1!
    @IBOutlet weak var phoneUnderLine: UnderlineShadowView!
    @IBOutlet weak var phoneCodeUnderLine: UnderlineShadowView!
    
    @IBOutlet weak var nickNameBtn: RoundButton1!
    @IBOutlet weak var nickNameUnderLine: UnderlineShadowView!
    
    
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
        self.emailTF.delegate = self
        self.passwordTF.delegate = self
        self.passwordConfirmTF.delegate = self
        self.phoneCodeTF.delegate = self
        self.phoneNumberTF.delegate = self
        self.nickNameTF.delegate = self
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
            self.resultL.text = ""
            self.validEmail(check: true)
        }else{
            self.resultL.text = "이메일 형식을 확인해주세요"
            self.validEmail(check: false)
        }
    }
    
    // 인증번호 발송 클릭
    @IBAction func verifyPhoneNumber(_ sender: Any){
        var phoneNum = self.phoneNumberTF.text ?? ""
        if phoneNum != "" && phoneNum.count > 6{
            phoneNum = phoneNum.replacingOccurrences(of: " ", with: "")
            phoneNum = phoneNum.replacingOccurrences(of: "-", with: "")
            self.resultL.text = ""
        }else{
            self.resultL.text = "휴대폰 번호가 유효하지 않습니다."
            validPhone(check: false)
            return
        }
        verifyPhoneNumberDataManager.verifyPhoneNumber(phoneNum, delegate: self)
    }
    // 인증번호 확인 클릭
    @IBAction func confirmVerifyPhoneNumber(_ sender: Any){
        
        self.resultL.text = ""
        
        if !phone_number_valid{
            self.resultL.text = "핸드폰번호가 유효하지 않습니다."
            validPhone(check: false)
            return
        }
        validPhone(check: true)
        let codeResponse = phoneCodeTF.text ?? ""
        
        if codeResponse != "" && phoneCodeId != nil{
            verifyPhoneNumberDataManager.ConfirmPhoneCode("\(phoneCodeId!)", "\(codeResponse)", delegate: self)
            validPhone(check: true)
        }else{
            self.resultL.text = "인증번호를 검증해주세요"
            
            validPhoneCode(check: false)
        }
    }
    //닉네임중복 클릭
    @IBAction func nickNameClick(_ sender: Any){
        if nickNameTF.text != ""{
            duplicationDataManager.duplicatedNickName(self.nickNameTF.text!, delegate: self)
            self.resultL.text = ""
        }else{
            validNickName(check: false)
            self.resultL.text = "닉네임을 입력해주세요"
        }
    }
    
    //다음버튼 클릭
    @IBAction func nextClick(_ sender: Any) {
        self.resultL.text = ""
        self.validTrue()
        if currentPage == 0{
            if !email_valid{
                self.resultL.text = "이메일이 유효하지 않습니다."
                self.validEmail(check: false)
                return
            }
            if (passwordTF.text?.count ?? 0) < 8{
                self.resultL.text = "비밀번호는 8자리 이상으로 입력해주세요"
                self.validPW(check: false)
                return
            }
            if (passwordTF.text != passwordConfirmTF.text) {
                self.resultL.text = "비밀번호가 일치하지 않습니다."
                self.validPW(check: false)
                return
            }
            self.signUpRequest.password = self.passwordTF.text
        }else if currentPage == 1{
            if !phone_number_valid{
                self.resultL.text = "휴대폰 번호가 유효하지 않습니다."
                self.validPhone(check: false)
                return
            }
            if !phone_valid{
                self.resultL.text = "인증번호를 검증해주세요"
                self.validPhoneCode(check: false)
                return
            }
        }else if currentPage == 2{
            self.signUpRequest.nickname = self.nickNameTF.text ?? "tester\(Int.random(in: 0...99999))"
            if nickName_valid{
                    if hasProfileImage{
                    let req = AWSNetworkManager.uploadImage(image: profileImage.image!)
                    req.done{
                        url in
                        print("succed: ", url)
                        self.signUpRequest.profileImageUrl = "\(url)"
                        self.goSignUp()
                    }.catch{
                            error in
                        print("error: ", error.localizedDescription)
                    }
                }else{
                    self.goSignUp()
                }
            }else{
                self.resultL.text = "닉네임 중복체크를 다시 해주세요"
                validNickName(check: false)
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
        self.resultL.text = "사용가능한 이메일입니다."
        self.emailValidBtn.backgroundColor = .green
        email_valid = true
        self.signUpRequest.email = self.emailTF.text
        self.signUpRequest.loginId = self.emailTF.text
        self.validEmail(check: true)
    }
    func didfailedEmail(){
        self.resultL.text = "이미 사용중인 이메일입니다."
        self.emailValidBtn.backgroundColor = .white
        email_valid = false
        self.signUpRequest.email = nil
        self.validEmail(check: false)
    }
    
    // 핸드폰인증
    func didSuccessRequestSMS(result: Int){
        self.resultL.text = "인증번호 요청 성공"
        phone_number_valid = true
        self.signUpRequest.phoneNumber = phoneNumberTF.text
        phoneCodeId = result
        self.validPhone(check: true)
    }
    // 인증코드 검증
    func didSuccessConfirmPhoneCode(){
        self.resultL.text = "인증성공"
        self.signUpRequest.phoneNumber = phoneNumberTF.text
        phone_valid = true
        self.validPhoneCode(check: true)
    }
    func didFailedConfirmPhoneCode(){
        self.signUpRequest.phoneNumber = nil
        self.resultL.text = "인증번호가 올바르지 않습니다."
        self.validPhoneCode(check: false)
    }
    
    func didSuccessNickName(){
        nickName_valid = true
        self.resultL.text = "사용가능한 닉네임입니다."
        self.validNickName(check: true)
    }
    func didfailedNickName(){
        nickName_valid = false
        self.resultL.text = "존재하는 닉네임입니다."
        self.validNickName(check: false)
    }
    // 회원가입 성공
    func didSuccessSignUp(result: PostSignUpResult?){
        
        self.resultL.text = "회원가입 성공"
        DispatchQueue.main.async {
            Thread.sleep(forTimeInterval: 1)
            self.performSegue(withIdentifier: "goHomeFromRegist", sender: self)
            Constant.DID_SUCCESS_SIGN_UP = true
        }
    }
    // 회원가입 실패
    func failedToRequest(message: String){
        self.resultL.text = message
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
            self.hasProfileImage = true
        }
        dismiss(animated: true, completion: nil)
    }
}

extension RegistVC{
    func goSignUp(){
        signUpRequest.nickname = self.nickNameTF.text ?? "test\(Int.random(in: 0...9999))"
        if self.signUpRequest.phoneNumber != nil && self.signUpRequest.email != nil && self.signUpRequest.nickname != nil && self.signUpRequest.loginId != nil{
            self.signUpDataManager.postSignUp(signUpRequest, delegate: self)
        }
    }
}
//MARK: 값 유효에 따른 색상변환
extension RegistVC{
    func validEmail(check: Bool){
        if !check{
            self.emailValidBtn.backgroundColor = .invalidRed
            self.emailValidBtn.setTitleColor(.white, for: .normal)
            self.emailValidUnderLine.backgroundColor = .invalidRed
        }else{
            self.emailValidBtn.backgroundColor = .white
            self.emailValidBtn.setTitleColor(.invalidRed, for: .normal)
            self.emailValidUnderLine.backgroundColor = .white
        }
    }
    
    func validPW(check: Bool){
        if !check{
            for i in self.passwordUnderLine{
                i.backgroundColor = .invalidRed
            }
        }else{
            for i in self.passwordUnderLine{
                i.backgroundColor = .white
            }
        }
    }
    
    func validPhone(check: Bool){
        if !check{
            self.phoneValidBtn.backgroundColor = .invalidRed
            self.phoneValidBtn.setTitleColor(.white, for: .normal)
            self.phoneUnderLine.backgroundColor = .invalidRed
        }else{
            self.phoneValidBtn.backgroundColor = .white
            self.phoneValidBtn.setTitleColor(.invalidRed, for: .normal)
            self.phoneUnderLine.backgroundColor = .white
        }
    }
    
    func validPhoneCode(check: Bool){
        if !check{
            self.phoneCodeValidBtn.backgroundColor = .invalidRed
            self.phoneCodeValidBtn.setTitleColor(.white, for: .normal)
            self.phoneCodeUnderLine.backgroundColor = .invalidRed
        }else{
            self.phoneCodeValidBtn.backgroundColor = .white
            self.phoneCodeValidBtn.setTitleColor(.invalidRed, for: .normal)
            self.phoneCodeUnderLine.backgroundColor = .white
        }
    }
    
    func validNickName(check: Bool){
        if !check{
            self.nickNameUnderLine.backgroundColor = .invalidRed
            self.nickNameBtn.setTitleColor(.white, for: .normal)
            self.nickNameBtn.backgroundColor = .invalidRed
        }else{
            self.nickNameUnderLine.backgroundColor = .white
            self.nickNameBtn.setTitleColor(.invalidRed, for: .normal)
            self.nickNameBtn.backgroundColor = .white
        }
    }
    func validTrue(){
        self.validEmail(check: true)
        self.validPW(check: true)
        
        self.validPhone(check: true)
        self.validPhoneCode(check: true)
  
        self.validNickName(check: true)
    }
}

extension RegistVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

