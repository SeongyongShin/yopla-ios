//
//  RecipeModifyViewController.swift
//  yopla
//
//  Created by 신성용 on 2021/12/06.
//

import UIKit
import Kingfisher
import AVFoundation
import Photos
import MobileCoreServices


class RecipeModifyVC: BaseViewController{
    lazy var modifyDataManager: ModifyRecipeDataManager = ModifyRecipeDataManager()
    let awsDataManager = AWSDataManager()
    var modifyData: GetRecipeDetailResponse?
    var modify_available = false
    var video_img: [UIImage] = []
    var videoURL : NSURL?
    var current_section = 0
    var current_item = 0
    @IBOutlet weak var modifyLabel: UILabel!
    var modifyST:ModifyST?{
        didSet{
            if current_section == 0{
                let cell = self.modifyCV.cellForItem(at: IndexPath(item: 0, section: 0)) as! ModifyThumbCell
                cell.recipeImage.image = modifyST!.img
                cell.is_modified_img = true
            }else{
                
                let cell = self.modifyCV.cellForItem(at: IndexPath(item: current_item, section: current_section)) as! ModifyDetailCell
                cell.recipeImage.image = modifyST!.img
                cell.is_modified_img = true
                cell.fileUrl = modifyST!.filePath
                cell.fileType = modifyST!.type
                modifyData!.result2![current_item].detailFileUrl = modifyST!.filePath!
                modifyData!.result2![current_item].fileType = modifyST!.type
            }
        }
    }
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    lazy var getRecipeDetail: GetModifyRecipeDetailDataManager = GetModifyRecipeDetailDataManager()
    @IBOutlet weak var modifyCV: UICollectionView!
    @IBOutlet weak var activityV: UIActivityIndicatorView!
    @IBOutlet weak var loadingV: UIView!
    let imagePickerController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setComponent()
    }
    
    @IBAction func homePressed(_ sender: Any) {
        self.makeTabBarRootVC("MainTabBar")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRecipeDetail.getRecipeDetail2(delegate: self)
    }
    @IBAction func modifyPressed(_ sender: Any) {
        self.loadingV.isHidden = false
        self.activityV.startAnimating()
        self.modifyCV.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        self.modifyLabel.text = "수정 중입니다. 잠시 기다려주세요."
        DispatchQueue.main.async { [self] in
            Thread.sleep(forTimeInterval: 0.1)
            let cell = self.modifyCV.cellForItem(at: IndexPath(item: 0, section: 0)) as! ModifyThumbCell
            if cell.is_modified_img{
                if cell.recipeImage.image != nil{
                        let req = self.awsDataManager.uploadImage(image: cell.recipeImage.image!)
                        req.done{ [self]
                            url in
                            self.modifyData!.result?.recipeImage = "\(url)"
                            self.modifyDataManager.patchThumbNail(PostThumbNailRequest(recipeId:Constant.CURRENT_RECIPE, recipeName: modifyData!.result!.title, category: modifyData!.result!.category ?? "한식", time: modifyData!.result!.times ?? "정성을 다한 요리", frontImageUrl: "\(url)", tags: modifyData!.result!.tags?.components(separatedBy: " ") ?? []), delegate: self)
                            DispatchQueue.main.async {
                                self.modifyCV.scrollToItem(at: IndexPath(item: 0, section: 1), at: .right, animated: false)
                            }
                        }.catch{
                            error in

                        print("error: ", error.localizedDescription)
                    }
                    
                }
            }else{
                self.modifyDataManager.patchThumbNail(PostThumbNailRequest(recipeId:Constant.CURRENT_RECIPE, recipeName: modifyData!.result!.title, category: modifyData!.result!.category ?? "한식", time: modifyData!.result!.times ?? "정성을 다한 요리", frontImageUrl: modifyData!.result!.recipeImage, tags: modifyData!.result!.tags?.components(separatedBy: " ") ?? []), delegate: self)

            }
        }
        
    }
}

extension RecipeModifyVC{
    func setComponent(){
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        imagePickerController.delegate = self
        self.loadingV.isHidden = true
        self.modifyCV.register(UINib(nibName: "ModifyThumbCell", bundle: nil), forCellWithReuseIdentifier: "ModifyThumbCell")
        self.modifyCV.register(UINib(nibName: "ModifyDetailCell", bundle: nil), forCellWithReuseIdentifier: "ModifyDetailCell")
        modifyCV.delegate = self
        modifyCV.dataSource = self
    }
}

extension RecipeModifyVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            if modify_available{
                return modifyData!.result2!.count
            }
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ModifyThumbCell", for: indexPath) as! ModifyThumbCell
            if modify_available{
                if self.modifyData?.result != nil{
                    let item = self.modifyData!.result!
                    cell.camera.isHidden = true
                    if !cell.is_modified_img{
                        cell.recipeImage.kf.setImage(with: URL(string:item.recipeImage), placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil)
                    }
                    cell.recipeTitle.text = item.title
                    var tagString = ""
                    for i in item.tags!.split(separator: ","){
                        tagString = tagString + " \(i)"
                    }
                    cell.categoryDidSet = item.category
                    cell.timeDidSet = item.times
                    cell.recipeTag.text = tagString
                    cell.recipeCategory.setTitle(item.category, for: .normal)
                    cell.recipeTime.setTitle(item.times, for: .normal)
                    
                    cell.fileUrl = item.recipeImage
                }
            }
            cell.delegate = self
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ModifyDetailCell", for: indexPath) as! ModifyDetailCell
            cell.tag = indexPath.item
            if modify_available{
                if self.modifyData?.result2 != nil{
                    let item = self.modifyData!.result2![indexPath.item]
                    
                    if self.modifyData!.result2![indexPath.item].modified ?? "" != "true"{
                        if item.fileType == "video"{
                            if self.video_img[indexPath.item] == UIImage(){
                                    var img: UIImage = UIImage(){
                                        didSet {
                                            if self.modifyData!.result2![indexPath.item].modified ?? "" != "true"{
                                                DispatchQueue.main.async {
                                                    cell.recipeImage.image = img
                                                    self.video_img[indexPath.item] = img
                                                }
                                            }
                                        }
                                    }
                                DispatchQueue.global().async {
                                    img = self.createVideoThumbnail(from: URL(string: item.detailFileUrl)!) ?? UIImage()
                                }
                            }else{
                                cell.recipeImage.image = self.video_img[indexPath.item]
                            }
                            cell.fileType = "video"
                        }else{
                            cell.camera.isHidden = true
                            cell.recipeImage.kf.setImage(with: URL(string:item.detailFileUrl), placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil)
                            cell.fileType = "image"
                        }
                        cell.fileUrl = item.detailFileUrl
                        
                    }else{
                        cell.recipeImage.image = self.video_img[indexPath.item]
                        if self.modifyData!.result2![indexPath.item].fileType == "video"{
                            cell.camera.isHidden = false
                        }
                    }
                    
                    cell.cell_item = indexPath.item
                    cell.recipeTitle.text = item.title
                    cell.recipeIngredient.text = item.ingredients
                    cell.recipeContent.text = item.contents
                    cell.delegate = self
                }
            }
            return cell
        }
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



extension RecipeModifyVC{
    func didSuccessDetail(result: GetRecipeDetailResponse){
        self.modifyData = result
        if result.result2 != nil{
//            self.setStaticThumbNail(result: result.result2!)
            
            for _ in 0...result.result2!.count{
                self.video_img.append(UIImage())
            }
            
            
        }
        self.modify_available = true
        self.modifyCV.reloadData()
//        self.profileIV.kf.setImage(with: URL(string:result.result!.userProfileImage!), placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil)
    }
    func failedToRequest(message: String){
        self.presentBottomAlert(message: message)
    }
    func createVideoThumbnail(from url: URL) -> UIImage? {

        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
//        assetImgGenerate.maximumSize = CGSize(width: frame.width, height: frame.height)

        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        }
        catch {
          print(error.localizedDescription)
          return nil
        }
    }
}

extension RecipeModifyVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    // 갤러리에서 이미지 선택
    @objc func selectImageFromGallery(){
        imagePickerController.sourceType = .savedPhotosAlbum
        self.present(imagePickerController, animated: true, completion: nil)
    }
    //선택한 이미지 등록
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if current_section == 0{
            let cell = self.modifyCV.cellForItem(at: IndexPath(item: 0, section: 0)) as! ModifyThumbCell
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
            cell.is_modified_img = true
                    if mediaType.isEqual(to: kUTTypeImage as NSString as String) {
                        let captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
                            self.modifyST = ModifyST(img: captureImage!, type: "image", filePath: "")
                            cell.camera.isHidden = true
                            cell.recipeImage.image = captureImage
                        }
                        
                        
                    }
                    else if mediaType.isEqual(to: kUTTypeMovie as NSString as String) {
                        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
                            
                            let imageUrl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
                            do {
                                let asset = AVURLAsset(url: imageUrl! as URL , options: nil)
                                let imgGenerator = AVAssetImageGenerator(asset: asset)
                                imgGenerator.appliesPreferredTrackTransform = true
                                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                                let thumbnail = UIImage(cgImage: cgImage)
                                cell.recipeImage.image = thumbnail
                                self.modifyST = ModifyST(img: thumbnail, type: "image", filePath: "")
                            } catch let error {
                                print("*** Error generating thumbnail: \(error.localizedDescription)")
                            }
                            
                        }
                    }
            
            dismiss(animated: true, completion: nil)
        }
        else{
            var size1: Float = 0.0
        let cell = self.modifyCV.cellForItem(at: IndexPath(item: current_item, section: current_section)) as! ModifyDetailCell
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString

                if mediaType.isEqual(to: kUTTypeImage as NSString as String) {
                    let captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                    if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
                        self.modifyST = ModifyST(img: captureImage!, type: "image", filePath: "")
                        cell.fileType = "image"
                        cell.camera.isHidden = true
                        if current_item < modifyData!.result2!.count{
                            self.modifyData!.result2![current_item].fileType = "image"
                            self.video_img[current_item] = captureImage!
                            self.modifyData!.result2![current_item].modified = "true"
                            
                            print("section, item: ",current_section, current_item)
                        }
                    }
                    
                    
                }
                else if mediaType.isEqual(to: kUTTypeMovie as NSString as String) {
                    if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
                        
                        let imageUrl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
                        do {
                            let asset = AVURLAsset(url: imageUrl! as URL , options: nil)
                            let imgGenerator = AVAssetImageGenerator(asset: asset)
                            imgGenerator.appliesPreferredTrackTransform = true
                            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                            let thumbnail = UIImage(cgImage: cgImage)
                            
                            if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
                                size1 = Float(getSize(asset: asset).split(separator: " ")[0]) ?? 0
                                
                                if size1 < 15.0{
                                    cell.fileType = "video"
                                    cell.camera.isHidden = false
                                    let url: URL? = asset.returnURL()
                                    if url != nil{
                                        self.modifyST = ModifyST(img: thumbnail, type: "video", filePath: "\(url!)")
                                        if current_item < modifyData!.result2!.count{
                                            self.modifyData!.result2![current_item].fileType = "video"
                                            self.video_img[current_item] = thumbnail
                                            self.modifyData!.result2![current_item].modified = "true"
                                        }
                                    }else{
                                        self.presentAlert(title: "파일에 접근할 수 없습니다.")
                                    }
                                }
                           }

                            
                           
                            
                        } catch let error {
                            print("*** Error generating thumbnail: \(error.localizedDescription)")
                        }
                        
                    }
                }
        
        dismiss(animated: true, completion: nil)
        if size1 > 15.0{
            self.presentAlert(title: "15MB 이하만 등록 가능합니다.\n \(size1)MB / 15MB")
            cell.is_modified_img = true
        }}
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


extension RecipeModifyVC: ModifyCell{
    func getPhoto(section: Int, item: Int){
        current_section = section
        current_item = item
        print("section, item: ",current_section, current_item)
        present(imagePickerController, animated: true, completion: nil)
    }
    func modifyData(section: Int, item: Int){
        current_section = section
        current_item = item
        if section == 0{
            let cell = self.modifyCV.cellForItem(at: IndexPath(item: 0, section: 0)) as! ModifyThumbCell
            modifyData!.result?.title = cell.recipeTitle.text!
            modifyData!.result?.tags = cell.recipeTag.text!
            modifyData!.result?.category = cell.categoryDidSet!
            modifyData!.result?.times = cell.timeDidSet!
        }else{
            let cell = self.modifyCV.cellForItem(at: IndexPath(item: item, section: section)) as! ModifyDetailCell
            modifyData!.result2![item].title = cell.recipeTitle.text!
            modifyData!.result2![item].ingredients = cell.recipeIngredient.text!
            modifyData!.result2![item].contents = cell.recipeContent.text!
        }
    }
    
    
}

extension RecipeModifyVC{
    func didSuccessRegistthumbNail(result: Int){
        self.modifyLabel.text = "1 페이지 수정 중"
        DispatchQueue.global().async {
            self.setDetailAPI(index: 0)
        }
    }
    
    func didSuccessPostDetail(result: String){
        self.activityV.stopAnimating()
        self.loadingV.isHidden = true
        self.presentAlert(title: "수정 완료")
            
    }
    
    func setModifyMsg(msg: String){
        DispatchQueue.main.async {
            self.modifyLabel.text = msg
        }
    }
    
    func setDetailAPI(index: Int){
        
        if index >= self.modifyData!.result2!.count{
            self.modifyDetail()
            return
        }
        
        let item: GetRecipeDetail = self.modifyData!.result2![index]
        // 사진 또는 동영상이 수정되었을 경우
        if item.modified != nil{
            //이미지인 경우
            if item.fileType == "image"{
                let req = awsDataManager.uploadImage(image: self.video_img[index])
                req.done{
                    url in
                    self.modifyData!.result2![index].detailFileUrl = "\(url)"
                    self.setModifyMsg(msg: "\(index + 1) 페이지 수정 완료")
                    self.setDetailAPI(index: index + 1)
                }.catch{
                        error in
                    print("error: ", error.localizedDescription)
                    self.loadingV.isHidden = true
                    self.activityV.stopAnimating()
                    self.presentAlert(title: "업로드에 문제가 발생했습니다.")
                }
            }
            //동영상인 경우
            else{
                let req = awsDataManager.uploadVideo(with: URL(string: item.detailFileUrl)!)
                req.done{
                    url in
                    self.modifyData!.result2![index].detailFileUrl = "\(url)"
                    self.setModifyMsg(msg: "\(index + 1) 페이지 수정 완료")
                    self.setDetailAPI(index: index + 1)
                }.catch{
                        error in
                    print("error: ", error.localizedDescription)
                    self.loadingV.isHidden = true
                    self.activityV.stopAnimating()
                    self.presentAlert(title: "업로드에 문제가 발생했습니다.")
                }
            }
            
        }
        //사진수정 안했을 때
        else{
            self.setModifyMsg(msg: "\(index + 1) 페이지 수정 완료")
            self.setDetailAPI(index: index + 1)
        }
        
    }
    
    func modifyDetail(){
        //작업 완료
        var modifyDetails: [PostNewRecipe] = []
        for i in modifyData!.result2!{
            let temp_Detail = PostNewRecipe(title: i.title, ingredients: i.ingredients, contents: i.contents, detailFileUrl: i.detailFileUrl, fileType: i.fileType)
            modifyDetails.append(temp_Detail)
        }
        modifyDataManager.patchDetail(PostDetailRequest(recipeId: Constant.CURRENT_RECIPE, newRecipeDetails: modifyDetails), delegate: self)
    }
    
    func getSize(asset: PHAsset) -> String {
        let resources = PHAssetResource.assetResources(for: asset)

        guard let resource = resources.first,
              let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong else {
                  return "Unknown"
              }

        let sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64))
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB]
        bcf.countStyle = .file
        return bcf.string(fromByteCount: sizeOnDisk)
    }
}
