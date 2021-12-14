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
    @IBOutlet weak var guestBtn: BaseButton!
    
    @IBOutlet weak var startYopla: UIButton!
    @IBOutlet weak var inTroV: UIView!
    @IBOutlet weak var introCV: UICollectionView!
    var is_logged = false
    
    override var shouldAutorotate: Bool {
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        introCV.delegate = self
        introCV.dataSource = self
        loginBtn.backgroundColor = .mainHotPink
        registBtn.setTitleColor(.mainHotPink, for: .normal)
        registBtn.backgroundColor = .white
        startYopla.layer.borderWidth = 2
        startYopla.layer.borderColor = UIColor.white.cgColor
        startYopla.layer.cornerRadius = 5
        self.navigationController?.navigationBar.tintColor = .black

    }
    @IBAction func loginGuest(_ sender: Any) {
        Constant.USER_IDX = 12
        Constant.JWT_TOKEN = "eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWR4IjoxMiwiaWF0IjoxNjM4OTgxODYzLCJleHAiOjE2NDA0NTMwOTJ9.s1ifjDIYB_6VoxXvlqJ_mKwu-R9B9rUiHeaYCosG7vc"
        makeTabBarRootVC("MainTabBar")
        Constant.IS_GUEST = true
    }
    @IBAction func startClicked(_ sender: Any) {
        self.inTroV.isHidden = true
        Constant.APP_INTRO = true
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
        Constant.IS_GUEST = false
        inTroV.isHidden = true
        if Constant.APP_INTRO == nil{
            Constant.APP_INTRO = false
        }
        
        if Constant.APP_INTRO!{
            inTroV.isHidden = true
        }else{
            inTroV.isHidden = false
        }
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
            self.guestBtn.isHidden = true
            self.is_logged = true
        }else{
            self.loginBtn.isHidden = false
            self.registBtn.isHidden = false
            self.guestBtn.isHidden = false
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

extension StartVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntroCell", for: indexPath) as! IntroCell
    
        let device = deviceModelName()
        if device == "iPad" || device == "iPadMini"{
            cell.img.image = UIImage(named: "p\(indexPath.item + 1)")
        }else{
            cell.img.image = UIImage(named: "s\(indexPath.item + 1)")
        }
        
        if indexPath.item == 0{
            cell.backgroundColor = .s1
        }else if indexPath.item == 1{
            cell.backgroundColor = .s2
        }else if indexPath.item == 2{
            cell.backgroundColor = .s3
        }else if indexPath.item == 3{
            cell.backgroundColor = .s4
        }else{
            cell.backgroundColor = .s5
        }
        return cell
    }
    
    // 셀 크기 화면 꽉차게
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)
    }
    //셀 중앙정렬
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if collectionView.tag == 0{
            let totalCellWidth = self.view.frame.width
            let leftInset = (self.view.frame.width - CGFloat(totalCellWidth))
            let rightInset = leftInset
            return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        }
        return UIEdgeInsets()
    }
}
extension StartVC{
    func getDeviceIdentifier() -> String {

            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            return identifier
        }
    func deviceModelName() -> String {

            let model = UIDevice.current.model
            switch model {

            case "iPhone":
                return "iPhone"
            case "iPad":
                return "iPad"
            case "iPad mini" :
                return "iPadMini"
            default:
                return "Unknown Model : \(model)"
            }
        }
}
