//
//  MyPageVC.swift
//  yopla
//
//  Created by 신성용 on 2021/12/02.
//

import UIKit
import Photos
import Kingfisher

class MyPageVC: BaseViewController {
    lazy var modifyDataManager: ModifyProfileDataManager = ModifyProfileDataManager()
    lazy var AWSNetworkManager: AWSDataManager = AWSDataManager()
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var gradeImage: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var gradeName: UILabel!
    @IBOutlet weak var progressV: UIProgressView!
    
    @IBOutlet var labelList: [UILabel]!
    @IBOutlet var gradeList: [UILabel]!
    
    let imagePickerController = UIImagePickerController()
    
    var next_grade = 0
    var time: Float = 0.0
    var timer: Timer?
    var perCent = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponent()
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        makeTabBarRootVC("MainTabBar")
    }
}

extension MyPageVC{
    func setComponent(){
        
        requestPhotosPermission()
        imagePickerController.delegate = self
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.selectImageFromGallery)))
        progressV.layer.cornerRadius = 10
        progressV.clipsToBounds = true


        let gradeScore = Constant.MY_PROFILE!.rankPoints
        
        if gradeScore < 1500{
            gradeImage.image = UIImage(named: "bronze")
            gradeName.textColor = .bronze
            gradeName.text = "동반인"
            self.next_grade = 1500
            labelList[1].textColor = .silver
            labelList[1].text = "은반인"
            labelList[3].text = "\(self.next_grade - gradeScore)P"
        }else if gradeScore < 5000{
            gradeImage.image = UIImage(named: "silver")
            gradeName.textColor = .silver
            gradeName.text = "은반인"
            self.next_grade = 5000
            labelList[1].textColor = .gold
            labelList[1].text = "금반인"
            labelList[3].text = "\(self.next_grade - gradeScore)P"
            gradeList[0].text = "1500P"
            gradeList[1].text = "5000P"
        }else{
            gradeImage.image = UIImage(named: "gold")
            gradeName.textColor = .gold
            gradeName.text = "금반인"
            self.next_grade = gradeScore
            for i in labelList{
                i.text = ""
            }
            labelList[0].text = "최고 등급을 달성하셨습니다!"
            labelList[1].textColor = .gold
            gradeList[0].text = "\(gradeScore)P"
            gradeList[1].text = "MAX!"
        }
        
        self.profileView.clipsToBounds = true
        self.profileView.layer.cornerRadius = 50
        
        if Constant.MY_PROFILE?.profileImage != nil{
            profileImage.kf.setImage(with: URL(string:Constant.MY_PROFILE!.profileImage!), placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil)
        }
        self.nickName.text = Constant.MY_PROFILE?.userNickName
        self.email.text = Constant.MY_PROFILE?.email
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(setProgress), userInfo: nil, repeats: true)
        self.perCent = Double(Constant.MY_PROFILE!.rankPoints) / Double(self.next_grade)
    }
    
    @objc func setProgress() {
        time += 0.1
        progressV.setProgress(time, animated: true)
        if Double(time) >= perCent {
            timer!.invalidate()
        }
    }
}
//MARK: 프로필 이미지 관련
extension MyPageVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    // 갤러리에서 이미지 선택
    @objc func selectImageFromGallery(){
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    //선택한 이미지 등록
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.originalImage]{
            profileImage.image = (image as! UIImage)
            let req = AWSNetworkManager.uploadImage(image: profileImage.image!)
            req.done{
                url in
//                print("succed: ", url)
                self.modifyDataManager.patchPI(ModifyPI(userId: Constant.USER_IDX!, newProfileImage: "\(url)"), delegate: self)
            }.catch{
                    error in
                print("error: ", error.localizedDescription)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    private func requestPhotosPermission() {
            let photoAuthorizationStatusStatus = PHPhotoLibrary.authorizationStatus()

            switch photoAuthorizationStatusStatus {
            case .authorized:
                print("Photo Authorization status is authorized.")

            case .denied:
                print("Photo Authorization status is denied.")

            case .notDetermined:
                print("Photo Authorization status is not determined.")
                PHPhotoLibrary.requestAuthorization() {
                    (status) in
                    switch status {
                    case .authorized:
                        print("User permiited.")
                    case .denied:
                        print("User denied.")
                        break
                    default:
                        break
                    }
                }

            case .restricted:
                print("Photo Authorization status is restricted.")
            default:
                break
            }
        }
    func checkCameraPermission(){
       AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
           if granted {
               print("Camera: 권한 허용")
           } else {
               print("Camera: 권한 거부")
           }
       })
    }
}
//MARK: API 관련
extension MyPageVC{
    func didSuccessPatchPI(){
        self.presentBottomAlert(message: "프로필 이미지를 수정했습니다.")
    }
    func failedToRequest(message: String){
        self.presentBottomAlert(message: message)
    }
}
