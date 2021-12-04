//
//  MySettingVC.swift
//  yopla
//
//  Created by 신성용 on 2021/12/02.
//

import UIKit

class MySettingVC: BaseViewController {
    lazy var dataManager: ModifyProfileDataManager = ModifyProfileDataManager()
    @IBOutlet weak var btn1: BaseButton!
    @IBOutlet weak var btn2: BaseButton!
    @IBOutlet weak var confirmV: UIView!
    @IBOutlet weak var modifyBtn: BaseButton!
    @IBOutlet var passwordTF: [UITextField]!
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmV.isHidden = true
        confirmV.layer.borderWidth = 1
        confirmV.layer.borderColor = UIColor.shadowGray.cgColor
        
        for i in passwordTF{
            i.backgroundColor = .shadowGray
            i.layer.cornerRadius = 5
            i.clipsToBounds = true
            i.delegate = self
        }
        modifyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        btn1.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        btn2.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
    @IBAction func deletePressed2(_ sender: Any) {
        
//        makeRootVC("Start","SwipeNav")
        dataManager.patchDetele(ModifyDelete(userId: Constant.USER_IDX!, password: self.passwordTF[0].text!), delegate: self)
    }
    @IBAction func cancelPressed(_ sender: Any) {
        
        self.confirmV.isHidden = true
    }
    @IBAction func modifyPressed(_ sender: Any) {
        for i in passwordTF{
            if (i.text?.count ?? 0) < 8{
                self.presentBottomAlert(message: "비밀번호는 8자리 이상으로 입력해주세요")
                return
            }
        }
        if passwordTF[1].text != passwordTF[2].text{
            self.presentBottomAlert(message: "새 비밀번호와 확인이 올바르지 않습니다.")
            return
        }
        else if passwordTF[0].text == passwordTF[1].text{
            self.presentBottomAlert(message: "동일한 비밀번호로는 변경할 수 없습니다.")
            return
        }
        dataManager.patchPW(ModifyPW(userId: Constant.USER_IDX!, userNickName: Constant.MY_PROFILE!.userNickName, loginId: Constant.MY_PROFILE!.email, lastPassword: self.passwordTF[0].text!, newPassword: self.passwordTF[1].text!, email: Constant.MY_PROFILE!.email), delegate: self)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        makeTabBarRootVC("MainTabBar")
    }
    @IBAction func logOutPressed(_ sender: Any) {
        self.didSuccessDelete()
    }
    @IBAction func deletePressed(_ sender: Any) {
        if self.passwordTF[0].text!.count < 8{
            self.presentBottomAlert(message: "비밀번호를 먼저 입력해주세요.")
            return
        }
        self.confirmV.isHidden = false
    }
    
}
//MARK: API 관련
extension MySettingVC{
    func didSuccessPatchPW(){
        self.presentBottomAlert(message: "비밀번호를 변경했습니다.")
    }
    func didSuccessDelete(){
        Constant.DID_LOG_OUT = true
        makeRootVC("Start","SwipeNav")
    }
    func failedToRequest(message: String){
        self.presentBottomAlert(message: message)
    }
}

extension MySettingVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

}
