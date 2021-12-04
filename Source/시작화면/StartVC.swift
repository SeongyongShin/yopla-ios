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
    var is_logged = false
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
        if is_logged{
            self.makeTabBarRootVC("MainTabBar")
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.clearCache()
        if Constant.DID_LOG_OUT{
            Constant.DID_LOG_OUT = false
            UserDefaults.standard.removeObject(forKey: "userIdx")
            UserDefaults.standard.removeObject(forKey: "jwt")
            Constant.videoUrls.removeAll()
            Constant.registThumbNail = nil
            Constant.registDetail.removeAll()
            Constant.registId = nil
            Constant.RECIPE_STAR = 4
            Constant.CURRENT_RECIPE = 0
            Constant.CURRENT_RECIPE_DETAIL = nil
            Constant.IS_BOOKMARK_PAGE = false
            Constant.PEOPLE_RECIPE_LIST = nil
            Constant.PUBLIC_RECIPE_LIST = nil
            Constant.CURRENT_MORE_RECIPE_TYPE = 0
            Constant.CURRENT_RECIPE_TYPE = 0
            Constant.IS_MODIFY_PAGE = false
            Constant.TEMPORARY_DETAIL_VIDEO_THUMB.removeAll()
            Constant.IS_CATEGORY = false
            Constant.CATEGORY_RESULT = nil
            Constant.CURRENT_CATEGORY = nil
            Constant.USER_IDX = nil
            Constant.JWT_TOKEN = nil
            is_logged = false
        }
        if UserDefaults.standard.value(forKey: "userIdx") != nil && UserDefaults.standard.value(forKey: "jwt") != nil{
            Constant.USER_IDX = UserDefaults.standard.value(forKey: "userIdx") as? Int
            Constant.JWT_TOKEN = UserDefaults.standard.value(forKey: "jwt") as? String
            self.loginBtn.isHidden = true
            self.registBtn.isHidden = true
            self.is_logged = true
        }else{
            self.loginBtn.isHidden = false
            self.registBtn.isHidden = false
            self.is_logged = false
        }
    }
    
    @IBAction func unwindToStart(_ sender: UIStoryboardSegue) {
    }
    func clearCache(){
        let cacheURL =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileManager = FileManager.default
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory( at: cacheURL, includingPropertiesForKeys: nil, options: [])
            for file in directoryContents {
                do {
                    try fileManager.removeItem(at: file)
                }
                catch let error as NSError {
                    debugPrint("Ooops! Something went wrong with delete cache: \(error)")
                }

            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

