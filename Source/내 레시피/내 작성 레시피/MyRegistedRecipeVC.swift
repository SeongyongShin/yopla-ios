//
//  MyRegistedRecipeVC.swift
//  yopla
//
//  Created by 신성용 on 2021/11/25.
//

import UIKit
import Kingfisher

class MyRegistedRecipeVC: UIViewController {
    lazy var dataManager: GetRegistedRecipeDataManager = GetRegistedRecipeDataManager()
    var itemList: [GetRegistedRecipeResult]?
    @IBOutlet weak var recipeTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponent()
        dataManager.getRecipeList(delegate: self)
    }
    
}



//MARK: 델리겟
extension MyRegistedRecipeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemList != nil{
            return itemList!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRegistedRecipeTableCell") as! MyRegistedRecipeTableCell
        let item = itemList![indexPath.row]
        cell.tag = item.recipeId
        cell.recipeIV.kf.setImage(with: URL(string:item.recipeImage), placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil)
        cell.recipeTitle.text = item.recipeName
        cell.recipeCategory.text = item.category
        cell.heartCount.text = "\(item.bookmarkCount)"
        cell.nameL.text = "수정하기"
        let star:Int = Int(item.averageScore)
        let floatScore = Float(star) - item.averageScore
        if star != 0{
            for i in 0...(star - 1){
                cell.stars[i].image = UIImage(systemName: "star.fill")
            }
            if floatScore >= 0.5 && star != 5{
                cell.stars[star-1].image = UIImage(systemName: "star.leadinghalf.filled")
            }
        }else{
            if floatScore > 0.5{
                cell.stars[0].image = UIImage(systemName: "star.leadinghalf.filled")
            }
        }

        return cell
    }
    
    
}

//MARK: API
extension MyRegistedRecipeVC{
    func didSuccessRecipe(result: GetRegistedRecipeResponse){
        if let items = result.result{
            self.itemList = items
            self.recipeTV.reloadData()
        }
    }
    func failedToRequest(message: String){
        self.presentBottomAlert(message: message)
    }
}

//MARK: 컴포넌트 설정
extension MyRegistedRecipeVC{
    func setComponent(){
        self.recipeTV.dataSource = self
        self.recipeTV.delegate = self
        self.recipeTV.register(UINib(nibName: "MyRegistedRecipeTableCell", bundle: nil), forCellReuseIdentifier: "MyRegistedRecipeTableCell")
        self.recipeTV.tableFooterView = UIView()
    }
}
