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
//        let yourBackImage = UIImage(named: "
        self.navigationController?.navigationBar.tintColor = .black
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func unwindToStart(_ sender: UIStoryboardSegue) {
    }
}
