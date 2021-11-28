//
//  RecipeDetailReviewVC.swift
//  yopla
//
//  Created by 신성용 on 2021/11/09.
//

import UIKit
import Kingfisher

class RecipeDetailReviewVC: BaseViewController{
    lazy var getReviewDataManager: GetRecipeReviewDataManager = GetRecipeReviewDataManager()
    lazy var postReviewDataManager: PostReviewDataManager = PostReviewDataManager()
    
    var recipeReviews: [GetRecipeReviewResult]?
    
    var keyboardHeight:CGFloat = 0
    var keyboardShow = false
    @IBOutlet weak var reviewContainerV: UIView!
    @IBOutlet weak var reviewPlaceHolder: UILabel!
    @IBOutlet weak var reviewTable: UITableView!
    @IBOutlet var reviewStars: [UIImageView]!
    @IBOutlet weak var reviewTV: UITextView!
    @IBOutlet weak var reviewV: UIView!
    @IBOutlet weak var reviewTopConstant: NSLayoutConstraint!
    @IBOutlet weak var reviewBottomConstant: NSLayoutConstraint!
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.swipeRecognizer(dst: "goToStarFromRecipeReview")
        setComponent()
        getReviewDataManager.getRecipeReview(recipeId: Constant.CURRENT_RECIPE, delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 키보드리스너 추가
        self.addKeyboardNotifications()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        // 키보드리스너 추가
        self.removeKeyboardNotifications()
        
    }
    @IBAction func reviewBtn(_ sender: UIButton){
        if self.reviewTV.text != nil && self.reviewTV.text.count > 4{
            let postRequest = PostReviewRequest(userId: Constant.USER_IDX, recipeId: Constant.CURRENT_RECIPE, content: self.reviewTV.text!, point: Constant.RECIPE_STAR)
            postReviewDataManager.postREview(postRequest, delegate: self)
        }else{
            self.presentBottomAlert(message: "리뷰를 5자 이상 입력해주세요")
        }
        self.reviewV.endEditing(true)
    }
}

// MARK: 컴포넌트 설정
extension RecipeDetailReviewVC{
    func setComponent(){
        self.reviewTable.delegate = self
        self.reviewTable.dataSource = self
        self.reviewTable.tableFooterView = UIView()
        self.reviewTable.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        self.reviewContainerV.layer.cornerRadius = 7
        self.reviewContainerV.layer.borderWidth = 1
        self.reviewContainerV.layer.borderColor = UIColor.mainHotPink.cgColor
        self.reviewTV.delegate = self
        for i in 0 ... 4{
            reviewStars[i].image = UIImage(systemName: "star")
        }
        for i in 0 ... Constant.RECIPE_STAR{
            reviewStars[i].image = UIImage(systemName: "star.fill")
        }
    }
    

}

//MARK: 터치이벤트
extension RecipeDetailReviewVC: UITextViewDelegate{
    // placeholder 추가/제거
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text! == ""{
            self.reviewPlaceHolder.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text! == ""{
            self.reviewPlaceHolder.text = "후기 작성하기(10자 이상)"
        }
    }
}

//MARK: 테이블뷰 델리겟
extension RecipeDetailReviewVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.recipeReviews != nil{
            return self.recipeReviews!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewCell
        cell.selectedBackgroundView = UIView()
        if let review = recipeReviews{
            let item = review[indexPath.row]
            if item.userPI != nil{
                cell.profileImage.kf.setImage(with: URL(string:item.userPI!), placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil)
                
            }
            cell.nickName.text = item.userNickName
            cell.content.text = item.content
            cell.created_at.text = item.createdAt
            
            for i in 0 ... 4{
                cell.stars[i].image = UIImage(systemName: "star")
            }
            if item.reviewScore != 5{
                for i in 0 ... item.reviewScore{
                    cell.stars[i].image = UIImage(systemName: "star.fill")
                }
            }
            else{
                for i in 0 ... 4{
                    cell.stars[i].image = UIImage(systemName: "star.fill")
                }
            }
            
        }
        return cell
    }
    
    
}

//MARK: 키보드만큼 올리기
extension RecipeDetailReviewVC{
    
    // 노티피케이션을 추가하는 메서드
    func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

    
    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillShow(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 올려준다.
        if keyboardShow{
            // 이미 키보드가 떠있으면
            return
        }
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
            self.reviewV.frame.origin.y -= self.keyboardHeight
            self.reviewBottomConstant.constant += self.keyboardHeight
            self.reviewV.layoutIfNeeded()
            keyboardShow = true
        }
        

    }
    
    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillHide(_ noti: NSNotification){
        
        if !keyboardShow{
            //키보드가 떠있지 않으면
            return
        }
        self.reviewV.frame.origin.y += self.keyboardHeight
        self.reviewBottomConstant.constant -= self.keyboardHeight
        self.reviewV.layoutIfNeeded()
        
        keyboardShow = false
    }
}

extension RecipeDetailReviewVC{
    func didSuccessPostReview(result: Int?){
        getReviewDataManager.getRecipeReview(recipeId: Constant.CURRENT_RECIPE, delegate: self)
    }
    func didSuccessGetReview(result: [GetRecipeReviewResult]?){
        self.recipeReviews = result
        self.reviewTable.reloadData()
    }
    func failedToRequest(message: String){
        self.presentBottomAlert(message: message)
    }
}

extension RecipeDetailReviewVC{
    @IBAction func goToMainFromReview(_ sender: UIButton){
        makeTabBarRootVC("MainTabBar")
    }
}
