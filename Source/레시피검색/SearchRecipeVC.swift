//
//  SearchRecipeVC.swift
//  yopla
//
//  Created by 신성용 on 2021/11/11.
//

import UIKit

class SearchRecipeVC: BaseViewController {
    var collection_count = 8
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var searchResultCV: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultCV.register(UINib(nibName: "RecipeProfile", bundle: nil), forCellWithReuseIdentifier: "RecipeProfile")
        searchResultCV.delegate = self
        searchResultCV.dataSource = self
//        searchResultCV.clipsToBounds = false
        filterBtn.layer.cornerRadius = 5
    }
    

}

extension SearchRecipeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection_count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeProfile", for: indexPath) as! RecipeProfileCell
        cell.smallMode()
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/2) - 5, height: collectionView.frame.width/2)
    }
    
}
