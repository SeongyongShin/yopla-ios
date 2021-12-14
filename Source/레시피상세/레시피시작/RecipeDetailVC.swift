//
//  RecipeDetailVC.swift
//  yopla
//
//  Created by 신성용 on 2021/11/06.
//

import UIKit
import Kingfisher
import AVFoundation
import Photos

class RecipeDetailVC: BaseViewController {
    
    lazy var getRecipeDetail: GetRecipeDetailDataManager = GetRecipeDetailDataManager()
    
    @IBOutlet weak var backGroundV: UIView!
    @IBOutlet weak var recipeTimerL: UILabel!
    @IBOutlet weak var recipeTitleL: UILabel!
    @IBOutlet weak var recipeTitleL2: UILabel!
    @IBOutlet weak var recipeHeartL: UILabel!
    @IBOutlet weak var recipeViewedL: UILabel!
    @IBOutlet weak var profileIV: RoundImageView!
    @IBOutlet weak var nickNameL: UILabel!
    @IBOutlet weak var hashTagL: UILabel!
    @IBOutlet weak var recipeIV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backGroundV.layer.cornerRadius = 5
        
            getRecipeDetail.getRecipeDetail(delegate: self)
//        //대중
//        if Constant.CURRENT_RECIPE_TYPE == 0{
//            getRecipeDetail.getPublicRecipeDetail(delegate: self)
//        }
//        //갓반인
//        else{
//            getRecipeDetail.getRecipeDetail(delegate: self)
//        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.makeTabBarRootVC("MainTabBar")
    }
    
}

//MARK: API
extension RecipeDetailVC{
    func didSuccessDetail(result: GetRecipeDetailResponse){
        Constant.CURRENT_RECIPE_DETAIL = result
        if result.result2 != nil{
            self.setStaticThumbNail(result: result.result2!)
        }
        
        self.recipeTitleL.text = result.result?.title ?? "제목이 없습니다."
        self.recipeTitleL2.text = result.result?.title ?? "제목이 없습니다."
        self.recipeIV.kf.setImage(with: URL(string:result.result!.recipeImage), placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil)
        if result.result!.userProfileImage != nil{
            self.profileIV.kf.setImage(with: URL(string:result.result!.userProfileImage!), placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil)
        }
        self.nickNameL.text = result.result?.userNickName ?? "정보가 없습니다."
        self.recipeHeartL.text = "\(result.result?.bookmarkCount ?? 0)"
        self.recipeViewedL.text = "\(result.result?.hits ?? 0)"
        self.recipeTimerL.text = "\(result.result?.times ?? "")"
        if let tags = result.result?.tags{
            let tagList = tags.split(separator: ",")
            for i in tagList{
                let str1 = i.replacingOccurrences(of: "#", with: "")
                self.hashTagL.text = self.hashTagL.text! + " #\(str1)"
            }
        }else{
            self.hashTagL.text = ""
        }
    }
    func failedToRequest(message: String){
        self.presentBottomAlert(message: message)
    }
}

extension RecipeDetailVC{
    @IBAction func unwindToDetail(_ sender: UIStoryboardSegue) {
        
    }
}
extension RecipeDetailVC{
    func setStaticThumbNail(result: [GetRecipeDetail]){
        for _ in result{
            Constant.TEMPORARY_DETAIL_VIDEO_THUMB.append(UIImage())
        }
        DispatchQueue.global().async {
            Constant.THUMBNAIL_PROGRESS = true
            var index = 0
            for item in result{
                if Constant.THUMBNAIL_PROGRESS == false{
                    break
                }
                if item.fileType == "video"{
                    let img = self.createVideoThumbnail(from: URL(string: item.detailFileUrl)!) ?? UIImage()
                    if Constant.THUMBNAIL_PROGRESS &&  Constant.TEMPORARY_DETAIL_VIDEO_THUMB.count != 0{
                        Constant.TEMPORARY_DETAIL_VIDEO_THUMB[index] = img
                    }else{
                        return
                    }
//                    Constant.TEMPORARY_DETAIL_VIDEO_THUMB.append(self.createVideoThumbnail(from: URL(string: item.detailFileUrl)!) ?? UIImage())
                }else{
                    Constant.TEMPORARY_DETAIL_VIDEO_THUMB[index] = UIImage()
                }
                index += 1
            }
        }
    }
    
    private func createVideoThumbnail(from url: URL) -> UIImage? {

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
