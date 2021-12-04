//
//  MoreRecipeVC.swift
//  yopla
//
//  Created by 신성용 on 2021/11/26.
//

import UIKit

class MoreRecipeVC: BaseViewController {
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var moreCV: UICollectionView!
    lazy var getMorePeopleRecipeDataManager: GetMorePeopleRecipeDataManager = GetMorePeopleRecipeDataManager()
    var itemList: [GetPeopleRecipeThumnails]?
    override func viewDidLoad() {
        super.viewDidLoad()
        moreCV.register(UINib(nibName: "RecipeProfile", bundle: nil), forCellWithReuseIdentifier: "RecipeProfile")
        moreCV.delegate = self
        moreCV.dataSource = self
        moreCV.clipsToBounds = true
        
        if !Constant.IS_CATEGORY{
            self.setComponent()
            self.getAPI()
        }else{
            self.title1.text = Constant.CURRENT_CATEGORY!
            self.title2.text = "더보기!"
            self.itemList = Constant.CATEGORY_RESULT ?? []
        }
    }
    
    @IBAction func homePressed(_ sender: Any) {
        self.makeTabBarRootVC("MainTabBar")
    }
    
}
//MARK: 델리겟
extension MoreRecipeVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.itemList != nil{
            return self.itemList!.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeProfile", for: indexPath) as! RecipeProfileCell
        cell.smallMode()
        cell.layoutIfNeeded()
        let item = itemList![indexPath.item]
        
        cell.recipeIdx = item.recipeIdx
        cell.rpImage.kf.setImage(with: URL(string:item.recipeImage), placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil)
        if let userUrl = item.userProfileImage{
            cell.rpProfile.kf.setImage(with: URL(string:userUrl), placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil)
        }
        if item.bookmarked{
            cell.rpBookmark.image = UIImage(systemName: "bookmark.fill")
            cell.rpBookmark1.image = UIImage(systemName: "bookmark.fill")
        }else{
            cell.rpBookmark.image = UIImage(systemName: "bookmark")
            cell.rpBookmark1.image = UIImage(systemName: "bookmark")
        }
        cell.rpNickName.text = item.userNickName
        cell.rpTitle.text = item.title
        cell.rpHeartCount.text = "\(item.bookmarkCount)"
        cell.rpViewCount.text = "\(item.hits)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RecipeProfileCell
        Constant.CURRENT_RECIPE = cell.recipeIdx
        print(cell.recipeIdx, Constant.CURRENT_RECIPE)
        self.performSegue(withIdentifier: "goToDetailFromMore", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/2) - 5, height: collectionView.frame.width/2)
    }
    
    
    
}
//MARK: 컴포넌트 설정
extension MoreRecipeVC{
    func setComponent(){

        if Constant.CURRENT_MORE_RECIPE_TYPE == 0{
            self.title1.text = "숏(SHORT!)"
            self.title2.text = "레시피"
        }else if Constant.CURRENT_MORE_RECIPE_TYPE == 1{
            self.title1.text = "HOT!"
            self.title2.text = "인기 레시피"
        }else{
            self.title1.text = "\(Constant.MY_PROFILE?.userNickName ?? "###")님께"
            self.title2.text = "추천 레시피"
        }
    }
    func getAPI(){
        //대중 레시피 더보기
        if Constant.CURRENT_RECIPE_TYPE == 0{
            getMorePeopleRecipeDataManager.getPublicRecipe(more_type: Constant.CURRENT_MORE_RECIPE_TYPE, delegate: self)
        }
        //갓반인 레시피 더보기
        else{
            getMorePeopleRecipeDataManager.getPeopleRecipe(more_type: Constant.CURRENT_MORE_RECIPE_TYPE, delegate: self)
        }
    }
}
//MARK: API
extension MoreRecipeVC{
    func didSuccessRequestPeopleRecipe(result: [GetPeopleRecipeThumnails]?){
        if result != nil{
            self.itemList = result
            self.moreCV.reloadData()
        }
        
    }
    func failedToRequest(message: String){
        self.presentBottomAlert(message: message)
    }
}
