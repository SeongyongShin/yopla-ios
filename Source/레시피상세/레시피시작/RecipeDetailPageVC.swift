//
//  RecipeDetailPageVC.swift
//  yopla
//
//  Created by 신성용 on 2021/11/07.
//

import UIKit
import Kingfisher
import AVFoundation
import AVKit
//import VideoToolbox

class RecipeDetailPageVC: BaseViewController, SwipeProtocol {

    var current_page = 0
    var max_page = 1
    @IBOutlet weak var recipeTitleL: UILabel!
    @IBOutlet weak var recipeSmallTitleL: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var recipeImageCV: UICollectionView!
    @IBOutlet weak var recipeIngredient: UILabel!
    @IBOutlet weak var recipeContent: UITextView!
    let detailItem = Constant.CURRENT_RECIPE_DETAIL
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCV()
        self.setComponent()
        max_page = Constant.CURRENT_RECIPE_DETAIL!.result2!.count
        pageControl.numberOfPages = max_page
        let swipe1 = UISwipeGestureRecognizer(target: self, action: #selector(self.direction))
        let swipe2 = UISwipeGestureRecognizer(target: self, action: #selector(self.direction))
        swipe1.direction = .left
        swipe2.direction = .right
        self.view.addGestureRecognizer(swipe1)
        self.view.addGestureRecognizer(swipe2)
        
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.goToVC("unwindToDetail")
    }
    
    @objc func direction(_ swipe: UISwipeGestureRecognizer){
        switch swipe.direction{
        case .left:
            self.directionToLeft()
        case .right:
            self.directionToRight()
        default:
            break
        }
    }
    
    @objc func directionToLeft() {
        if current_page == max_page - 1{
            self.goToVC("goToStar")
        }else{
            current_page += 1
            self.setCollectionPos()
        }
    }
    @objc func directionToRight() {
        if current_page == 0{
//            self.goToVC("unwindToDetail")
        }else{
            current_page -= 1
            self.setCollectionPos()
        }
    }
}

//MARK: 터치이벤트
extension RecipeDetailPageVC{
    //레시피 페이지 이동
    @objc func moveDirection(_ sender: UITapGestureRecognizer){
        if sender.view?.tag == 1 && current_page == (max_page - 1){
            self.goToVC("goToStar")
        }
        
        if sender.view?.tag == 0 && current_page != 0{
            current_page -= 1
        }else if sender.view?.tag == 1 && current_page != (max_page - 1){
            current_page += 1
        }else{
            return
        }
        self.setCollectionPos()
    }
    func setCollectionPos(){
        pageControl.currentPage = current_page
        let item = self.detailItem!.result2![current_page]
        self.setPage(title: item.title, ingredient: item.ingredients, content: item.contents)
        let rect = self.recipeImageCV.layoutAttributesForItem(at: IndexPath(row: current_page, section: 0))?.frame
        self.recipeImageCV.scrollRectToVisible(rect!, animated: true)
    }
}

//MARK: 컴포넌트 설정
extension RecipeDetailPageVC{
    func setCV(){
        recipeImageCV.delegate = self
        recipeImageCV.dataSource = self
    }
    func setComponent(){
        if let item = self.detailItem!.result2?[0]{
            self.setPage(title: item.title, ingredient: item.ingredients, content: item.contents)
        }
        self.recipeTitleL.text = Constant.CURRENT_RECIPE_DETAIL!.result!.title
    }
    func setPage(title: String, ingredient: String, content: String){
        self.recipeSmallTitleL.text = title
        self.recipeIngredient.text = ingredient
        self.recipeContent.text = content
    }
}

// MARK: 디테일뷰 델리겟
extension RecipeDetailPageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Constant.CURRENT_RECIPE_DETAIL!.result2!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! RecipeDetailCell
        
        if cell.fileType == "video"{
            if cell.recipeImage.image == UIImage(){
                if Constant.TEMPORARY_DETAIL_VIDEO_THUMB[indexPath.item] == UIImage(){
                    var hasImage = false
                    DispatchQueue.global().async {
                        for _ in 0...4{
                            Thread.sleep(forTimeInterval: 1)
                            if Constant.TEMPORARY_DETAIL_VIDEO_THUMB[indexPath.item] != UIImage(){
                                hasImage = true
                                break
                            }
                        }
                        if hasImage{
                            DispatchQueue.main.async {
                                
                                cell.recipeImage.image = Constant.TEMPORARY_DETAIL_VIDEO_THUMB[indexPath.item]
                                cell.playImage.isHidden = false
                            }
                        }
                    }
                    
                    
                }
            }else{
                
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailImageCell", for: indexPath) as! RecipeDetailCell
        cell.tonext.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveDirection)))
        cell.tonext.isUserInteractionEnabled = true
        cell.toprev.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveDirection)))
        cell.toprev.isUserInteractionEnabled = true
        cell.loadingV.isHidden = true
        if let item = self.detailItem?.result2![indexPath.item]{
            if item.fileType == "video"{
//                DispatchQueue.main.async { [self] in
//                    cell.recipeImage.image = createVideoThumbnail(from: URL(string: item.detailFileUrl)!)
//                }
//                print(item.detailFileUrl
                
                DispatchQueue.main.async {
                    if Constant.TEMPORARY_DETAIL_VIDEO_THUMB.count != 0{
                        cell.recipeImage.image = Constant.TEMPORARY_DETAIL_VIDEO_THUMB[indexPath.item]
                        if Constant.TEMPORARY_DETAIL_VIDEO_THUMB[indexPath.item] == UIImage(){
                            DispatchQueue.global().async {
                                var count = 0
                                let img = UIImage()
                                while true{
                                    Thread.sleep(forTimeInterval: 0.1)
                                    if count == 100{
                                        break
                                    }
                                    if indexPath.item < Constant.TEMPORARY_DETAIL_VIDEO_THUMB.count && Constant.TEMPORARY_DETAIL_VIDEO_THUMB[indexPath.item] != img{
                                        DispatchQueue.main.async {
                                            cell.recipeImage.image = Constant.TEMPORARY_DETAIL_VIDEO_THUMB[indexPath.item]
                                        }
                                        break
                                    }
                                    count += 1
                                }
                            }
                        }
                    }else{
                        var tempCount = 0
                        while Constant.TEMPORARY_DETAIL_VIDEO_THUMB.count == 0{
                            Thread.sleep(forTimeInterval: 1)
                            // 10초까지 기다려준다.
                            if tempCount == 10{
                                break
                            }
                            tempCount += 1
                        }
                        if Constant.TEMPORARY_DETAIL_VIDEO_THUMB.count == 0{
                            self.presentBottomAlert(message: "동영상 썸네일을 불러오는 데 실패했습니다.")
                            cell.recipeImage.image = UIImage()
                        }else{
                            
                            cell.recipeImage.image = Constant.TEMPORARY_DETAIL_VIDEO_THUMB[indexPath.item]
                        }
                    }
                }

            }else{
                cell.fileType = "image"
                cell.recipeImage.kf.setImage(with: URL(string:item.detailFileUrl), placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil)
                cell.playImage.isHidden = true
            }
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
            let totalCellWidth = self.view.frame.width * CGFloat(self.max_page * 2)
            let leftInset = (self.view.frame.width - CGFloat(totalCellWidth))
            let rightInset = leftInset
            return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        }
        return UIEdgeInsets()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RecipeDetailCell
        if cell.fileType == "video"{
            DispatchQueue.main.async {
                cell.loadingV.isHidden = false
                cell.indicatorV.startAnimating()
            }
            CacheManager.shared.getFileWith(stringUrl: self.detailItem!.result2![indexPath.item].detailFileUrl) { result in
                    switch result {
                    case .success(let url):
                        let player = AVPlayer(url: url)
                        // Create a new AVPlayerViewController and pass it a reference to the player.
                        let controller = AVPlayerViewController()
                        controller.player = player
                        // Modally present the player and call the player's play() method when complete.
                        self.present(controller, animated: true) {
                            player.play()
                        }
                        DispatchQueue.main.async {
                            cell.loadingV.isHidden = true
                            cell.indicatorV.stopAnimating()
                        }
                    case .failure(let error):
                        // handle errror
//                        print(error)
                        self.presentAlert(title: "영상을 찾을 수 없습니다.")
                    }
                }
        }

    }

}

extension RecipeDetailPageVC{
    @IBAction func unwindToDetailPage(_ sender: UIStoryboardSegue) {
        
    }
    
    @IBAction func goToMainFromDetail(_ sender: UIButton) {
        makeTabBarRootVC("MainTabBar")
    }
}

extension RecipeDetailPageVC{
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
