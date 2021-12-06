//
//  RegistRecipeDetailVC.swift
//  yopla
//
//  Created by 신성용 on 2021/11/15.
//

import UIKit
import Kingfisher
import AVFoundation

class RegistRecipeDetailVC: BaseViewController {
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var recipeName: UILabel!
    var thumbImage: UIImage = UIImage()
    //현재 페이지
    var currentDetailPage = 0
    //이미지선택
    var currentCellState = 0
    var tempDetail = DetailPage()
    let awsDataManager = AWSDataManager()
    lazy var postThumbNailDataManager: PostThumbNailDataManager = PostThumbNailDataManager()
    lazy var PostDetailDataManager: PostDetailDataManager = yopla.PostDetailDataManager()
    var modify_available = false
    var modify_count = 0
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var minusImage: UIImageView!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    var tempDetailList: [DetailPage] = []
    
    @IBOutlet weak var registDetailCV: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponent()
        if Constant.IS_MODIFY_PAGE{
            DispatchQueue.global().async {
                self.setModifyList()
            }
        }
    }
    @IBAction func backPressed(_ sender: Any) {
        if currentCellState == 0{
            if self.currentDetailPage == 0{
                self.performSegue(withIdentifier: "goToThumbNailFromDetail", sender: self)
            }else{
                self.getDetail()
            }
        }else{
            self.registDetailCV.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}
//MARK: 컴포넌트 설정
extension RegistRecipeDetailVC{
    func setComponent(){
        for i in 1...2{
            registDetailCV.register(UINib(nibName: "RegistDetailCell\(i)", bundle: nil), forCellWithReuseIdentifier: "RegistDetailCell\(i)")
        }
        
        self.recipeName.text = Constant.tempThumbNails?.title ?? "무제"
        registDetailCV.delegate = self
        registDetailCV.dataSource = self
        self.loadingView.isHidden = true
        self.loadingView.layer.opacity = 0.5
        
        
    }
    func setModifyList(){
        for i in 0...(Constant.CURRENT_RECIPE_DETAIL!.result2!.count - 1){
            let item = Constant.CURRENT_RECIPE_DETAIL!.result2![i]
            var tempModify = DetailPage()
            tempModify.title = item.title
            tempModify.content = item.contents
            tempModify.fileType = item.fileType
            tempModify.ingredient = item.ingredients
            if item.fileType == "video"{
                tempModify.videoURL = URL(string: item.detailFileUrl)
                tempModify.image = self.createVideoThumbnail(from: URL(string: item.detailFileUrl)!)
                self.tempDetailList.append(tempModify)
                self.modify_count += 1
                if self.modify_count == Constant.CURRENT_RECIPE_DETAIL!.result2!.count{
                    self.modify_available = true
                    DispatchQueue.main.async {
                        self.registDetailCV.reloadData()
                    }
                }
            }else{
                downloadImage(with :item.detailFileUrl){
                    image in
                    tempModify.image = image
                    self.tempDetailList.append(tempModify)
                    self.modify_count += 1
                    if self.modify_count == Constant.CURRENT_RECIPE_DETAIL!.result2!.count{
                        self.modify_available = true
                        DispatchQueue.main.async {
                            self.registDetailCV.reloadData()
                        }
                    }
                }
            }
        }
        
    }
    func downloadImage(with urlString : String , imageCompletionHandler: @escaping (UIImage?) -> Void){
            guard let url = URL.init(string: urlString) else {
                return  imageCompletionHandler(nil)
            }
            let resource = ImageResource(downloadURL: url)
            
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    imageCompletionHandler(value.image)
                case .failure:
                    imageCompletionHandler(nil)
                }
            }
        }
}
//컬렉션뷰 설정
extension RegistRecipeDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item % 2 == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegistDetailCell1", for: indexPath) as! RegistDetailCell1
            cell.delegate = self
            cell.delegate2 = self
            if Constant.IS_MODIFY_PAGE && self.modify_available{
                if currentDetailPage < self.tempDetailList.count{
                    
                    let item = self.tempDetailList[currentDetailPage]
                    cell.thumbNailIV.image = item.image ?? UIImage()
                    cell.thumNailLabel.isHidden = true
                    cell.thumbNailIV.alpha = 1
                }
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegistDetailCell2", for: indexPath) as! RegistDetailCell2
            cell.delegate = self
            if Constant.IS_MODIFY_PAGE && self.modify_available{
                if currentDetailPage < self.tempDetailList.count{
                    let item = self.tempDetailList[currentDetailPage]
                    cell.smallThumNailIV.image = item.image ?? UIImage()
                    cell.titleTF.text = item.title
                    cell.ingredientTF.text = item.ingredient
                    cell.contentTV.text = item.content
                }
            }
            return cell
        }

    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if indexPath.item == 1{
            
            self.currentCellState = 1
            let cell = cell as! RegistDetailCell2
            
            if cell.currentDetailPage != self.currentDetailPage{
                cell.clear()
                cell.currentDetailPage = self.currentDetailPage
            }
            cell.pageControl.numberOfPages = self.tempDetailList.count + 1
            cell.pageControl.currentPage = currentDetailPage
            if currentDetailPage > 0{
                cell.prevBtn.isEnabled = true
            }else{
                cell.prevBtn.isEnabled = false
            }
            cell.smallThumNailIV.image = self.thumbImage
            self.homeImage.image = UIImage(named: "upload")
            self.minusImage.image = UIImage()
            if currentDetailPage == self.tempDetailList.count{
                    self.setButtonState(state: true)
            }
            
            if currentDetailPage < tempDetailList.count{
                let tempObj = self.tempDetailList[currentDetailPage]
                cell.smallThumNailIV.image = tempObj.image
                cell.titleTF.text = tempObj.title
                cell.ingredientTF.text = tempObj.ingredient
                cell.contentTV.text = tempObj.content
                cell.contentPlaceHolderLB.text = ""
                cell.nextBtn.setTitle("다음 페이지", for: .normal)
            }else{
                cell.smallThumNailIV.image = self.thumbImage
                cell.nextBtn.setTitle("페이지 추가", for: .normal)
            }
        }else{
            self.currentCellState = 0
            let cell = cell as! RegistDetailCell1
            self.minusImage.image = UIImage(systemName: "chevron.right")
            if cell.currentDetailPage != self.currentDetailPage{
                cell.clear()
                cell.currentDetailPage = self.currentDetailPage
            }
            self.homeImage.image = UIImage(systemName: "house.fill")
            self.setButtonState(state: false)
            if currentDetailPage < tempDetailList.count{
                if self.tempDetailList[currentDetailPage].fileType == "video"{
                    cell.videoDirectory = self.tempDetailList[currentDetailPage].videoURL
                }
                cell.contentType = self.tempDetailList[currentDetailPage].fileType!
                cell.thumbNailIV.image = self.tempDetailList[currentDetailPage].image
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if indexPath.item == 0{
            self.currentCellState = 1
            self.homeImage.image = UIImage(named: "upload")
            self.setButtonState(state: false)

        }else{
            self.currentCellState = 0
            self.homeImage.image = UIImage(systemName: "house.fill")
            self.setButtonState(state: false)
        }

    }
    // 셀 크기 화면 꽉차게
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)
    }
    
    
}

extension RegistRecipeDetailVC: RegistRecipeDetailCellDelegate{
    func setimageInfo(image: UIImage){
        thumbImage = image
        self.tempDetail.image = image
    }
    
    func getImageInfo()->UIImage{
        return thumbImage
    }
    
    func goToDetail(){
//        self.performSegue(withIdentifier: "goToRegistRecipe", sender: self)
    }
    //다음버튼
    func setDetail() {
        
        let rect = self.registDetailCV.layoutAttributesForItem(at: IndexPath(row: 0, section: 0))?.frame
        self.registDetailCV.scrollRectToVisible(rect!, animated: false)
        self.thumbImage = UIImage()
        
        if self.currentDetailPage < self.tempDetailList.count{
            
            self.tempDetailList[currentDetailPage] = self.tempDetail
            self.thumbImage = self.tempDetailList[currentDetailPage].image ?? UIImage()
        }else{
            self.tempDetailList.append(self.tempDetail)
            self.tempDetail = DetailPage()
            
        }
        
        self.currentDetailPage += 1
        if self.currentDetailPage == self.tempDetailList.count{
            self.thumbImage = UIImage()
        }
        self.registDetailCV.reloadData()
    }
    //이전버튼
    func getDetail() {
        let rect = self.registDetailCV.layoutAttributesForItem(at: IndexPath(row: 1, section: 0))?.frame
        self.registDetailCV.scrollRectToVisible(rect!, animated: false)
        self.currentDetailPage -= 1
        if Constant.IS_MODIFY_PAGE{
            self.thumbImage = self.tempDetailList[self.currentDetailPage].image ?? UIImage(systemName: "play.circle")!
        }else{
            self.thumbImage = self.tempDetailList[self.currentDetailPage].image!
        }
        self.tempDetail = self.tempDetailList[self.currentDetailPage]
        self.registDetailCV.reloadData()
    }
    
    func setTempDetail(title: String?, content: String?, fileType: String?, ingredient: String?, image: UIImage?, videoURL: URL?) {
        if self.currentDetailPage < self.tempDetailList.count{
            
            self.tempDetail = self.tempDetailList[self.currentDetailPage]
            
            if title != nil{
                self.tempDetailList[self.currentDetailPage].title = title
            }
            if image != nil{
                self.tempDetailList[self.currentDetailPage].image = image
            }
            if content != nil{
                self.tempDetailList[self.currentDetailPage].content = content
            }
            if ingredient != nil{
                self.tempDetailList[self.currentDetailPage].ingredient = ingredient
            }
            if fileType != nil{
                self.tempDetailList[self.currentDetailPage].fileType = fileType
            }
            if videoURL != nil{
                self.tempDetailList[self.currentDetailPage].videoURL = videoURL
            }
        }
        if title != nil{
            self.tempDetail.title = title
        }
        if image != nil{
            self.tempDetail.image = image
        }
        if content != nil{
            self.tempDetail.content = content
        }
        if ingredient != nil{
            self.tempDetail.ingredient = ingredient
        }
        if fileType != nil{
            self.tempDetail.fileType = fileType
        }
        if videoURL != nil{
            self.tempDetail.videoURL = videoURL
        }

    }
    func modifyTempDetail(){
        
    }
    
    func presentAlert(msg: String) {
        self.presentBottomAlert(message: msg)
    }


}
extension RegistRecipeDetailVC
{

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    func setButtonState(state: Bool){
        self.minusImage.isHidden = state
        self.minusBtn.isHidden = state
    }
}
//MARK: 버튼 이벤트
extension RegistRecipeDetailVC{
    @IBAction func btnPressed(_ sender: UIButton){
        
        if self.currentCellState == 0 {
            if sender.tag == 2{
                makeTabBarRootVC("MainTabBar")
                
            }else{
                if self.currentCellState == 1{
//                    self.registDetailCV.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
                }else if self.currentCellState == 0{
                    let cell = self.registDetailCV.cellForItem(at: IndexPath(item: 0, section: 0)) as! RegistDetailCell1
                    if cell.thumbNailIV.image == UIImage(){
                        self.presentBottomAlert(message: "이미지를 선택해주세요")
                        return
                    }
                    self.registDetailCV.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
                }
            }
        }else{
            if sender.tag == 1{

            }
            else{
                DispatchQueue.main.async {
                    self.loadingView.isHidden = false
                    self.activityView.startAnimating()
                }
                
                let cell = self.registDetailCV.cellForItem(at: IndexPath(row: 1, section: 0)) as! RegistDetailCell2
                if self.currentDetailPage == self.tempDetailList.count{
                    if cell.titleTF.text!.count != 0 && cell.ingredientTF.text!.count != 0 && cell.contentTV.text!.count != 0{
                        self.tempDetail.title = cell.titleTF.text
                        self.tempDetail.content = cell.contentTV.text
                        self.tempDetail.ingredient = cell.ingredientTF.text
                        self.tempDetailList.append(self.tempDetail)
                        self.setThumbNailAPIAvailable()
                    }else{
                        DispatchQueue.main.async {
                            self.loadingView.isHidden = true
                            self.activityView.stopAnimating()
                        }
                        self.presentBottomAlert(message: "빈 칸을 채워주세요")
                    }
                }else{
                    if cell.titleTF.text!.count != 0 && cell.ingredientTF.text!.count != 0 && cell.contentTV.text!.count != 0{
                        self.tempDetail.title = cell.titleTF.text
                        self.tempDetail.content = cell.contentTV.text
                        self.tempDetail.ingredient = cell.ingredientTF.text
                        if self.tempDetail.image != nil{
                            self.tempDetailList[self.currentDetailPage].image = self.tempDetail.image
                        }
                        if self.tempDetail.fileType != nil{
                            self.tempDetailList[self.currentDetailPage].fileType = self.tempDetail.fileType
                        }
                        if self.tempDetail.title != nil{
                            self.tempDetailList[self.currentDetailPage].title = self.tempDetail.title
                        }
                        if self.tempDetail.content != nil{
                            self.tempDetailList[self.currentDetailPage].content = self.tempDetail.content
                        }
                        if self.tempDetail.ingredient != nil{
                            self.tempDetailList[self.currentDetailPage].ingredient = self.tempDetail.ingredient
                        }
                        if self.tempDetail.videoURL != nil{
                            self.tempDetailList[self.currentDetailPage].videoURL = self.tempDetail.videoURL
                        }
                        self.setThumbNailAPIAvailable()
                    }else{
                        DispatchQueue.main.async {
                            self.loadingView.isHidden = true
                            self.activityView.stopAnimating()
                        }
                        self.presentBottomAlert(message: "빈 칸을 채워주세요")
                    }
                }
                
                
            }
        }
    }
}
// 완료 후 처리
extension RegistRecipeDetailVC{
    func setThumbNailAPIAvailable(){
        let req = awsDataManager.uploadImage(image: (Constant.tempThumbNails?.image)!)
        req.done{
            url in
            Constant.registThumbNail = PostThumbNailRequest(userId: Constant.USER_IDX!, recipeName: Constant.tempThumbNails!.title!, category: Constant.tempThumbNails!.category!, time: Constant.tempThumbNails!.time!, frontImageUrl: "\(url)",  tags: Constant.tempThumbNails!.tag!)
            
            DispatchQueue.main.async {
                
                self.loadingLabel.text = "썸네일 등록 완료. 내용을 등록하는 중입니다."
            }
            self.setDetailAPIAvailable()
        }.catch{
            error in
            DispatchQueue.main.async {
                self.loadingView.isHidden = true
                self.activityView.stopAnimating()
            }
            self.presentAlert(title: "업로드에 실패하였습니다. ", message: "사진 권한이 모든 사진 선택이 아닐 경우 문제가 발생할 수 있습니다. 설정에서 사진 권한을 확인해주세요.")
        print("error: ", error.localizedDescription)
    }
    }
    func setDetailAPIAvailable(){
        var tempList:[TempDetailPage] = []
        var index = 0
        var uploadCount = 0
        for i in tempDetailList{
            if i.fileType == "image"{
                let req = awsDataManager.uploadImage(image: i.image!)
                let countIndex = index
                req.done{
                    url in
                    DispatchQueue.main.async {
                        self.loadingLabel.text = "내용 \(uploadCount)페이지 등록 완료"
                    }
                    let beforeList = PostNewRecipe(title: i.title!, ingredients: i.ingredient!, contents: i.content!, detailFileUrl: "\(url)", fileType: "image")
                    tempList.append(TempDetailPage(index: countIndex, detail: beforeList))
                    uploadCount += 1
                    
                    if uploadCount == self.tempDetailList.count{
                        let newDetail = tempList.sorted(by: {$0.index! < $1.index!})
                        self.setPostDetailAPIAvailable(dataList: newDetail)
                    }
                }.catch{
                    
                    error in
                    DispatchQueue.main.async {
                        self.loadingView.isHidden = true
                        self.activityView.stopAnimating()
                    }
                    self.presentAlert(title: "업로드에 실패하였습니다. ", message: "사진 권한이 모든 사진 선택이 아닐 경우 문제가 발생할 수 있습니다. 설정에서 사진 권한을 확인해주세요.")
                print("error: ", error.localizedDescription)
            }
            }else{
                let req = awsDataManager.uploadVideo(with: i.videoURL!)
                let countIndex = index
                req.done{
                    url in
                    DispatchQueue.main.async {
                        self.loadingLabel.text = "내용 \(uploadCount)페이지 등록 완료"
                    }
                    let beforeList = PostNewRecipe(title: i.title!, ingredients: i.ingredient!, contents: i.content!, detailFileUrl: "\(url)", fileType: "video")
                    tempList.append(TempDetailPage(index: countIndex, detail: beforeList))
                    uploadCount += 1
                    
                    if uploadCount == self.tempDetailList.count{
                        let newDetail = tempList.sorted(by: {$0.index! < $1.index!})
                        self.setPostDetailAPIAvailable(dataList: newDetail)
                    }
                }.catch{
                    error in
                    DispatchQueue.main.async {
                        self.loadingView.isHidden = true
                        self.activityView.stopAnimating()
                    }
                    
                    self.presentAlert(title: "업로드에 실패하였습니다. ", message: "사진 권한이 모든 사진 선택이 아닐 경우 문제가 발생할 수 있습니다. 설정에서 사진 권한을 확인해주세요.")
                print("error: ", error.localizedDescription)
            }
            }
            index += 1

        }

    }
    func setPostDetailAPIAvailable(dataList: [TempDetailPage]){
        for i in dataList{
            Constant.registDetail.append(i.detail)
        }
        if Constant.IS_MODIFY_PAGE{
            Constant.registThumbNail?.recipeId = Constant.CURRENT_RECIPE
            self.postThumbNailDataManager.patchThumbNail(Constant.registThumbNail!, delegate: self)
        }else{
            self.postThumbNailDataManager.postThumbNail(Constant.registThumbNail!, delegate: self)
        }
    }
}

//MARK: 등록 결과
extension RegistRecipeDetailVC{
    func didSuccessRegistthumbNail(result: Int){
        if Constant.IS_MODIFY_PAGE{
            self.PostDetailDataManager.patchThumbNail(PostDetailRequest(recipeId: Constant.CURRENT_RECIPE, newRecipeDetails: Constant.registDetail), delegate: self)
        }else{
            self.PostDetailDataManager.postThumbNail(PostDetailRequest(recipeId: result, newRecipeDetails: Constant.registDetail), delegate: self)
        }
    }
    func didSuccessPostDetail(result: String){
        
        DispatchQueue.main.async {
            self.activityView.stopAnimating()
            self.loadingLabel.text = "레시피를 등록했습니다."
        }
        DispatchQueue.main.async {
            Thread.sleep(forTimeInterval: 2)
            self.loadingView.isHidden = true
            self.makeTabBarRootVC("MainTabBar")
            Constant.viewFromDetail = true
        }
    }
    func failedToRequest(message: String){
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.activityView.stopAnimating()
        }
        self.presentBottomAlert(message: message)
    }
}

extension RegistRecipeDetailVC: RegistCellDelegate{
    func didSelectedImage() {
        DispatchQueue.main.async {
            self.registDetailCV.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    func presentAlertMessage(msg: String){
        self.presentAlert(title: msg)
    }
}

extension RegistRecipeDetailVC{
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
