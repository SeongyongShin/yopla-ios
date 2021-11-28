//
//  RecipeDetailPageVC.swift
//  yopla
//
//  Created by 신성용 on 2021/11/07.
//

import UIKit
import Kingfisher

class RecipeDetailPageVC: BaseViewController {

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
    }

}

//MARK: 터치이벤트
extension RecipeDetailPageVC{
    //레시피 페이지 이동
    @objc func moveDirection(_ sender: UITapGestureRecognizer){
        if sender.view?.tag == 1 && current_page == (max_page - 1){
            self.performSegue(withIdentifier: "goToStar", sender: self)
        }
        
        if sender.view?.tag == 0 && current_page != 0{
            current_page -= 1
        }else if sender.view?.tag == 1 && current_page != (max_page - 1){
            current_page += 1
        }else{
            return
        }
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailImageCell", for: indexPath) as! RecipeDetailCell
        cell.tonext.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveDirection)))
        cell.tonext.isUserInteractionEnabled = true
        cell.toprev.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveDirection)))
        cell.toprev.isUserInteractionEnabled = true
        if let item = self.detailItem?.result2![indexPath.item]{
            if item.fileType == "video"{
                
            }else{
                cell.recipeImage.kf.setImage(with: URL(string:item.detailFileUrl), placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil)
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

}

extension RecipeDetailPageVC{
    @IBAction func unwindToDetailPage(_ sender: UIStoryboardSegue) {
        
    }
    
    @IBAction func goToMainFromDetail(_ sender: UIButton) {
        makeTabBarRootVC("MainTabBar")
    }
}
