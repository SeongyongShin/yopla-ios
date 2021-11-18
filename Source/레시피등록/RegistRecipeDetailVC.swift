//
//  RegistRecipeDetailVC.swift
//  yopla
//
//  Created by 신성용 on 2021/11/15.
//

import UIKit

class RegistRecipeDetailVC: BaseViewController {
    var thumbImage: UIImage = UIImage()
    var currentDetailPage = 0
    var currentCellState = 0
    var tempDetail = DetailPage()
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var minusImage: UIImageView!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    var tempDetailList: [DetailPage] = []
    
    @IBOutlet weak var registDetailCV: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponent()
    }
}
//MARK: 컴포넌트 설정
extension RegistRecipeDetailVC{
    func setComponent(){
        for i in 1...2{
            registDetailCV.register(UINib(nibName: "RegistDetailCell\(i)", bundle: nil), forCellWithReuseIdentifier: "RegistDetailCell\(i)")
        }
        
        registDetailCV.delegate = self
        registDetailCV.dataSource = self
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
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegistDetailCell2", for: indexPath) as! RegistDetailCell2
            cell.delegate = self
            return cell
        }

    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

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
            self.setButtonState(state: false)
            
            if currentDetailPage < tempDetailList.count{
                let tempObj = self.tempDetailList[currentDetailPage]
                cell.smallThumNailIV.image = tempObj.image
                cell.titleTF.text = tempObj.title
                cell.ingredientTF.text = tempObj.ingredient
                cell.contentTV.text = tempObj.content
                cell.contentPlaceHolderLB.text = ""
            }else{
                cell.smallThumNailIV.image = self.thumbImage
            }
        }else{
            self.currentCellState = 0
            let cell = cell as! RegistDetailCell1
            if cell.currentDetailPage != self.currentDetailPage{
                cell.clear()
                cell.currentDetailPage = self.currentDetailPage
            }
            self.homeImage.image = UIImage(systemName: "house.fill")
            self.setButtonState(state: true)
            if currentDetailPage < tempDetailList.count{
                cell.thumbNailIV.image = self.tempDetailList[currentDetailPage].image
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == 0{
            self.currentCellState = 1
            self.homeImage.image = UIImage(named: "upload")
            self.setButtonState(state: false)

        }else{
            self.currentCellState = 0
            self.homeImage.image = UIImage(systemName: "house.fill")
            self.setButtonState(state: true)
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
    func getDetail() {
        let rect = self.registDetailCV.layoutAttributesForItem(at: IndexPath(row: 1, section: 0))?.frame
        self.registDetailCV.scrollRectToVisible(rect!, animated: false)
        self.currentDetailPage -= 1
        self.thumbImage = self.tempDetailList[self.currentDetailPage].image!
        self.tempDetail = self.tempDetailList[self.currentDetailPage]
        self.registDetailCV.reloadData()
        
    }
    func setTempDetail(title: String?, content: String?, type: String?, ingredient: String?, image: UIImage?, videoURL: URL?) {

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
        if type != nil{
            self.tempDetail.type = type
        }
        if videoURL != nil{
            self.tempDetail.videoURL = videoURL
        }
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
            if type != nil{
                self.tempDetailList[self.currentDetailPage].type = type
            }
            if videoURL != nil{
                self.tempDetailList[self.currentDetailPage].videoURL = videoURL
            }
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
                self.performSegue(withIdentifier: "goToThumNailFromDetail", sender: self)
                Constant.viewFromDetail = true
            }
        }else{
            if sender.tag == 1{
                
            }else{
                
            }
        }
    }
}
