//
//  RecipeDetailStarVC.swift
//  yopla
//
//  Created by 신성용 on 2021/11/09.
//

import UIKit
import Kingfisher

class RecipeDetailStarVC: BaseViewController {
    lazy var reportDataManager: ReportDataManager = ReportDataManager()
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeBookMarkBtn: BaseButton!
    @IBOutlet var stars: [UIImageView]!
    @IBOutlet weak var starScore: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.swipeRecognizer(dst: "goToDetailPageFromStar")
        setComponent()
        setStarTapGesture()
    }

}

//MARK: 터치이벤트 설정
extension RecipeDetailStarVC{
    // 별점 선택
    @objc func setStar(_ sender: UITapGestureRecognizer){
        if Constant.IS_GUEST{
            self.presentAlert(title: "로그인 후 이용가능합니다.")
            return
        }
        for i in sender.view!.tag...4{
            self.stars[i].image = UIImage(systemName: "star")
        }
        for i in 0...sender.view!.tag{
            self.stars[i].image = UIImage(systemName: "star.fill")
        }
        starScore.text = "\(sender.view!.tag + 1).0"
        Constant.RECIPE_STAR = sender.view!.tag
    }
    @IBAction func bookMarking(_ sender: Any){
        if Constant.IS_GUEST{
            self.presentAlert(title: "로그인 후 이용가능합니다.")
            return
        }
        BookmarkDataManager().postBookMark(recipeId: Constant.CURRENT_RECIPE, delegate: self)
    }
    
    @IBAction func reportRecipe(_ sender: Any){
        if Constant.IS_GUEST{
            self.presentAlert(title: "로그인 후 이용가능합니다.")
            return
        }
        let c_r = Constant.CURRENT_RECIPE
        if c_r == 11 || c_r == 12 || c_r == 13 || c_r == 15 || c_r == 16{
            self.presentAlert(title: "YOPLA 공식 게시물은 신고할 수 없습니다.", message: "This recipe is offical yopla article so can't reported")
            return
        }
        if Constant.CURRENT_RECIPE_DETAIL?.result?.userNickName == Constant.MY_PROFILE?.userNickName{
            self.presentAlert(title: "자신의 게시물은 신고할 수 없습니다.")
            return
        }
        reportDataManager.postReport(ReportRequest(targetId: Constant.CURRENT_RECIPE, type: "recipe"), delegate: self)
    }
}

//MARK: 컴포넌트들 설정
extension RecipeDetailStarVC{
    // 컴포넌트 설정
    func setComponent(){
        self.recipeBookMarkBtn.setTitleColor(.black, for: .normal)
        for i in 0...4{
            self.stars[i].image = UIImage(systemName: "star")
        }
        for i in 0...Constant.RECIPE_STAR{
            self.stars[i].image = UIImage(systemName: "star.fill")
        }
        self.recipeTitle.text = Constant.CURRENT_RECIPE_DETAIL!.result!.title
        self.recipeImage.kf.setImage(with: URL(string:Constant.CURRENT_RECIPE_DETAIL!.result!.recipeImage), placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil)
    }
    func setStarTapGesture(){
        for i in stars{
            i.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setStar)))
            i.isUserInteractionEnabled = true
        }
    }
}
//통신
extension RecipeDetailStarVC{
    func didSuccessReportRecipe(){
        self.presentAlert(title: "신고하였습니다!")
    }
    func didSuccessBookMark(message: String){
        self.presentBottomAlert(message: message)
    }
    func failedToRequest(message: String){
        self.presentAlert(title: message)
    }
}
extension RecipeDetailStarVC{
    @IBAction func unwindToStar(_ sender: UIStoryboardSegue) {
        
    }
    @IBAction func goToMainFromReview(_ sender: UIButton){
        makeTabBarRootVC("MainTabBar")
    }
}
