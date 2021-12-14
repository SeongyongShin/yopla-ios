//
//  MyRegistedRecipeVC.swift
//  yopla
//
//  Created by 신성용 on 2021/11/25.
//

import UIKit
import Kingfisher

class MyRegistedRecipeVC: BaseViewController {
    var myRegistedDelegate: performSegues?
    lazy var dataManager: GetRegistedRecipeDataManager = GetRegistedRecipeDataManager()
    lazy var dataManager2: BookmarkDataManager = BookmarkDataManager()
    lazy var dataManager3: PostDeleteRecipeDataManager = PostDeleteRecipeDataManager()
    var itemList: [GetRegistedRecipeResult]?
    var bookMarkList: [GetBookMarkResult]?
    @IBOutlet weak var guestAlert: UIView!
    @IBOutlet weak var tabBarItems: UITabBarItem!
    @IBOutlet weak var home1: UIButton!
    @IBOutlet weak var home2: UIButton!
    @IBOutlet weak var recipeTV: UITableView!
    @IBOutlet weak var VCTitleLabel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponent()
        if Constant.IS_BOOKMARK_PAGE{
            dataManager2.getBookMark(delegate: self)
            VCTitleLabel.setTitle("북마크", for: .normal)
        }else{
            dataManager.getRecipeList(delegate: self)
            home1.isHidden = true
            home2.isHidden = true
        }
        if Constant.IS_GUEST{
            guestAlert.isHidden = false
        }
    }
    
    @IBAction func homePressed(_ sender: Any) {
        self.makeTabBarRootVC("MainTabBar")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Constant.IS_BOOKMARK_PAGE{
            dataManager2.getBookMark(delegate: self)
            VCTitleLabel.setTitle("북마크", for: .normal)
        }else{
            dataManager.getRecipeList(delegate: self)
            home1.isHidden = true
            home2.isHidden = true
        }
        if Constant.IS_GUEST{
            guestAlert.isHidden = false
        }
    }
}




//MARK: 델리겟
extension MyRegistedRecipeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemList != nil{
            return itemList!.count
        }else if bookMarkList != nil{
            return bookMarkList!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRegistedRecipeTableCell") as! MyRegistedRecipeTableCell
        cell.selectedBackgroundView = UIView()
        if itemList != nil{
            let item = itemList![indexPath.row]
            cell.delegate = self
            cell.current_type = 0
            cell.tag = item.recipeId
            cell.recipeIV.kf.setImage(with: URL(string:item.recipeImage), placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil)
            cell.recipeTitle.text = item.recipeName
            cell.recipeCategory.text = item.category
            cell.heartCount.text = "\(item.bookmarkCount)"
            cell.nameL.text = "수정하기"
            cell.is_people = true
            let star:Int = Int(item.averageScore)
            let floatScore = Float(star) - item.averageScore
            if star == 5{
                for i in 0...(star - 1){
                    cell.stars[i].image = UIImage(systemName: "star.fill")
                }
            }
            else if star != 0{
                for i in 0...star{
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
        }else if bookMarkList != nil{
            let item = bookMarkList![indexPath.row]
            
            if item.type == "people"{
                cell.is_people = true
            }
            
            cell.current_type = 1
            
            cell.delegate = self
            cell.tag = item.recipeId
            cell.recipeIV.kf.setImage(with: URL(string:item.recipeImage), placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil)
            cell.recipeTitle.text = item.recipeName
            cell.recipeCategory.text = item.category
            cell.heartCount.text = "\(item.bookmarkCount)"
            cell.nameL.text = item.userNickName
            cell.underLine.backgroundColor = .white
            let star:Int = Int(item.averageScore)
//            let floatScore = Float(star) - item.averageScore
            if star == 5{
                for i in 0...(star - 1){
                    cell.stars[i].image = UIImage(systemName: "star.fill")
                }
            }
            else if star != 0{
                for i in 0...star{
                    cell.stars[i].image = UIImage(systemName: "star.fill")
                }
                
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MyRegistedRecipeTableCell
        Constant.CURRENT_RECIPE = cell.tag
        if cell.is_people{
            Constant.CURRENT_RECIPE_TYPE = 1
        }else{
            Constant.CURRENT_RECIPE_TYPE = 0
        }
        if Constant.IS_BOOKMARK_PAGE{
            self.performSegue(withIdentifier: "goToDetailFromMyRegistedBookMark", sender: self)
        }else{
            myRegistedDelegate?.goToVC("goToDetail")
//            self.performSegue(withIdentifier: "goToDetailFromMyRegistedRecipe", sender: self)
        }
    }
}

//MARK: API
extension MyRegistedRecipeVC{
    func didSuccessDeleteRecipe(result: String){
        if result != "nil"{
            self.presentBottomAlert(message: "레시피를 삭제했습니다.")
            itemList = nil
            dataManager.getRecipeList(delegate: self)
            self.recipeTV.reloadData()
        }else{
            self.presentBottomAlert(message: "레시피를 삭제하지 못했습니다..")
        }
    }
    
    func didSuccessUnregistBookMark(message: String){
        dataManager2.getBookMark(delegate: self)
        self.recipeTV.reloadData()
        self.presentBottomAlert(message: message)
    }
    func didSuccessRequestBookMark(result: [GetBookMarkResult]?){
        if result != nil{
            self.bookMarkList = result!
            self.recipeTV.reloadData()
        }
    }
    
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

extension MyRegistedRecipeVC: BookMarkCellDelegate{
    func exitClicked(recipeId: Int, type: Int) {
        if type == 1{
            dataManager2.patchBookMark(recipeId: recipeId, delegate: nil, delegate2: self)
        }else{
            dataManager3.postDeleteRecipe(PostDeleteRecipeRequest(userId: Constant.USER_IDX!, recipeId: recipeId), delegate: self)
        }
    }
    func modifyPressed(recipeId: Int){
        Constant.IS_MODIFY_PAGE = true
        Constant.CURRENT_RECIPE = recipeId
        myRegistedDelegate?.goToVC("goToModify")
//        self.performSegue(withIdentifier: "goToRegistRecipeFromMyRegistedRecipe", sender: self)
    }
    
}
