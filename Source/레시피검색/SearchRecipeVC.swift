//
//  SearchRecipeVC.swift
//  yopla
//
//  Created by 신성용 on 2021/11/11.
//

import UIKit

class SearchRecipeVC: BaseViewController {
    lazy var searchDataManager:GetSearchRecipeDataManager = GetSearchRecipeDataManager()
    
    var searchData: [GetPeopleRecipeThumnails]?
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var searchResultCV: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultCV.register(UINib(nibName: "RecipeProfile", bundle: nil), forCellWithReuseIdentifier: "RecipeProfile")
        searchResultCV.delegate = self
        searchResultCV.dataSource = self
        searchResultCV.clipsToBounds = true
        filterBtn.layer.cornerRadius = 5
        
        self.searchTF.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        var searchType: [UIAction] = []
        for i in ["제목", "태그"]{
            searchType.append(UIAction(title: "\(i)", image: UIImage(), handler: {_ in self.filterBtn.setTitle("\(i)", for: .normal) }))
        }
        if #available(iOS 14.0, *) {
            filterBtn.menu = UIMenu(title: "",
                                       image: nil,
                                       identifier: nil,
                                       options: .displayInline,
                                       children: searchType)
        } else {
            return
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        var types = self.filterBtn.titleLabel?.text ?? "제목"
        if types == "제목"{
            types = "title"
        }else{
            types = "tag"
        }
        self.goSearch(type: types)
    }
}

extension SearchRecipeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchData != nil{
            return searchData!.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeProfile", for: indexPath) as! RecipeProfileCell
        cell.smallMode()
        cell.layoutIfNeeded()
        if searchData != nil{
            let item = searchData![indexPath.item]
            
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
            cell.rpHeartCount.text = "\(item.hits)"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RecipeProfileCell
        Constant.CURRENT_RECIPE = cell.recipeIdx
        print(cell.recipeIdx, Constant.CURRENT_RECIPE)
        self.performSegue(withIdentifier: "goToDetailFromSearch", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/2) - 5, height: collectionView.frame.width/2)
    }
    
}


extension SearchRecipeVC{
    func goSearch(type: String){
        searchDataManager.getSerchRecipe(word: self.searchTF.text ?? "", type: type, delegate: self)
    }
    @objc func textFieldDidChange(_ sender: Any?) {
        var types = self.filterBtn.titleLabel?.text ?? "제목"
        if types == "제목"{
            types = "title"
        }else{
            types = "tag"
        }
        self.goSearch(type: types)
     }
    func didSuccessSearch(result: GetSearchRecipeResponse){
        if result.result != nil{
            self.searchData = result.result!
        }else{
            self.searchData = nil
        }
        self.searchResultCV.reloadData()
    }
    func failedToRequest(message: String){
        self.presentBottomAlert(message: message)
    }
}
