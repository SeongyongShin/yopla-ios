//
//  StartVC.swift
//  yopla
//
//  Created by 신성용 on 2021/10/30.
//

import UIKit

class StartVC: BaseViewController {

    @IBOutlet weak var loginBtn: BaseButton!
    @IBOutlet weak var registBtn: BaseButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.backgroundColor = .mainHotPink
        registBtn.setTitleColor(.mainHotPink, for: .normal)
        registBtn.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black

    }
    override func viewDidAppear(_ animated: Bool) {
        if Constant.DID_SUCCESS_SIGN_UP{
            self.presentBottomAlert(message: "회원가입 성공! 로그인을 해주세요")
            Constant.DID_SUCCESS_SIGN_UP = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func unwindToStart(_ sender: UIStoryboardSegue) {
    }
}
