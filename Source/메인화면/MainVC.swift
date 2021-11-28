//
//  MainVC.swift
//  yopla
//
//  Created by 신성용 on 2021/11/02.
//

import UIKit
import Kingfisher

class MainVC: BaseViewController {
    lazy var recipeDataManager: GetRecipeDataManager = GetRecipeDataManager()
    var adBanner: [GetPeopleRecipeResult]?
    var shortRecipe: [GetPeopleRecipeThumnails]?
    var hotRecipe: [GetPeopleRecipeThumnails]?
    var recommendRecipe: [GetPeopleRecipeThumnails]?
    
    @IBOutlet weak var myMenuV: UIView!
    @IBOutlet weak var myMenuConst: NSLayoutConstraint!
    @IBOutlet weak var myMenuBackV: UIView!
    @IBOutlet weak var blurV: UIVisualEffectView!
    @IBOutlet weak var maneTV: UITableView!
    var myMenuList = ["내 정보", "내 레시피", "주문내역", "장바구니", "설정"]
    
    @IBOutlet weak var menuV: UIView!
    @IBOutlet weak var registRecipeBtn: RoundButton1!
    
    @IBOutlet weak var commonRecipe: UILabel!
    @IBOutlet weak var personRecipe: UILabel!
    @IBOutlet weak var recipeIndicator: UIView!
    @IBOutlet weak var recipeIndicatorConstant: NSLayoutConstraint!
    @IBOutlet weak var adBannerCV: UICollectionView!
    @IBOutlet weak var categoryCV: UICollectionView!
    @IBOutlet weak var popularCV: UICollectionView!
    @IBOutlet weak var recommandCV: UICollectionView!
    @IBOutlet weak var shortRPCV: UICollectionView!
    @IBOutlet weak var shortViewConstant: NSLayoutConstraint!
    @IBOutlet weak var popularCVConstant: NSLayoutConstraint!
    @IBOutlet weak var popularCVTopConstant: NSLayoutConstraint!
    @IBOutlet weak var recommandCVConstant: NSLayoutConstraint!
    var current_tab = 0
    var category_list = ["한식", "양식", "일-중식", "아시안", "후식", "베이커리", "카페", "주류", "비건", "다이어트"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 대중or갓반인레시피 터치 설정
        setLabelTouch()
        
        // 컬렉션뷰 잡아주기
        setCV()
        
        setComponent()
        

    }
    override func viewWillAppear(_ animated: Bool) {
        myMenuConst.constant = -self.view.frame.width
        myMenuV.layoutIfNeeded()
        self.clearConstant()
        DispatchQueue.global().async {
            self.recipeDataManager.getPublicRecipe(delegate: self)
        }
        DispatchQueue.global().async {
            self.recipeDataManager.getPeopleRecipe(delegate: self)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if Constant.viewFromDetail{
            self.presentBottomAlert(message: "레시피를 등록했습니다.")
            Constant.viewFromDetail = false
        }
    }
}

//MARK: 라벨 터치 타겟 설정
extension MainVC{
    
    func setLabelTouch(){
        commonRecipe.isUserInteractionEnabled = true
        personRecipe.isUserInteractionEnabled = true
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(self.changeView))
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(self.changeView))
        commonRecipe.addGestureRecognizer(tapGestureRecognizer1)
        personRecipe.addGestureRecognizer(tapGestureRecognizer2)
    }
    
    @objc func tabMenu(_ sender: UITapGestureRecognizer){
        let tag = sender.view!.tag
        //메뉴버튼
        if tag == 0{
            showSideBar()
        }
        //검색버튼
        else if tag == 1{
            self.performSegue(withIdentifier: "goSearchFromMain", sender: self)
        }
        //edit 버튼
        else if tag == 2{
            self.performSegue(withIdentifier: "goMyRegistedRecipe", sender: self)
        }
        //heart 버튼
        else{
            self.performSegue(withIdentifier: "goMyrecipeReview", sender: self)
        }
    }
    //북마크 or 알림 터치
    @IBAction func tabBookBell(_ sender: UIButton){
        //북마크
        if sender.tag == 0{
            Constant.IS_BOOKMARK_PAGE = true
            self.performSegue(withIdentifier: "goMyRegistedRecipe", sender: self)
        }
        //알림
        else{
            
        }
    }
    
    //더보기
    @IBAction func moreView(_ sender: UIButton){
        Constant.CURRENT_MORE_RECIPE_TYPE = sender.tag
        self.performSegue(withIdentifier: "goToMoreRecipe", sender: self)
    }

}

//MARK: 터치 시 함수
extension MainVC{
    // 라벨 터치 시 호출함수
    @objc func changeView(_ sender: UITapGestureRecognizer){
        //대중 레시피
        if sender.view?.tag == 0 && current_tab != 0{
            UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            changeViewSubFunc(sender.view!.tag, labelEnabled: true, indicatorX: 0)
            shortViewConstant = shortViewConstant.setMultiplier(multiplier: 0.01)
            popularCVTopConstant.constant = -10
            shortRPCV.isHidden = true
            Constant.CURRENT_RECIPE_TYPE = 0
            if Constant.PUBLIC_RECIPE_LIST != nil{
                let result = Constant.PUBLIC_RECIPE_LIST!
                self.adBanner = result.result
//                self.shortRecipe = result.shorts
                self.hotRecipe = result.hots
                self.recommendRecipe = result.recommend
                self.reloadCV()
            }
            
        }
        //갓반인 레시피
        else if sender.view?.tag == 1 && current_tab != 1{
            UserDefaults.standard.set(true, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            changeViewSubFunc(sender.view!.tag, labelEnabled: false, indicatorX: recipeIndicator.frame.width)
            popularCVTopConstant.constant = 30
            shortViewConstant = shortViewConstant.setMultiplier(multiplier: 0.4)
            shortRPCV.isHidden = false
            Constant.CURRENT_RECIPE_TYPE = 1
            
            if Constant.PUBLIC_RECIPE_LIST != nil{
                let result = Constant.PEOPLE_RECIPE_LIST!
                self.adBanner = result.result
                self.shortRecipe = result.shorts
                self.hotRecipe = result.hots
                self.recommendRecipe = result.recommend
                self.reloadCV()
            }
        }
    }
    
    // 인디케이터 이동, 색상변환 함수
    func changeViewSubFunc(_ tag: Int, labelEnabled: Bool, indicatorX: CGFloat){
        commonRecipe.isEnabled = labelEnabled
        personRecipe.isEnabled = !labelEnabled
        current_tab = tag
        
        recipeIndicatorConstant.constant = indicatorX
        UIViewPropertyAnimator(duration: 0.15, curve: .linear){
            self.recipeIndicator.frame.origin.x = indicatorX
        }.startAnimation()
    }
    
}

// MARK: 컴포넌트 설정
extension MainVC{
    func setCV(){
        maneTV.dataSource = self
        maneTV.delegate = self
        
        adBannerCV.dataSource = self
        adBannerCV.delegate = self
        categoryCV.dataSource = self
        categoryCV.delegate = self
        shortRPCV.dataSource = self
        shortRPCV.delegate = self
        shortRPCV.clipsToBounds = false
        popularCV.dataSource = self
        popularCV.delegate = self
        popularCV.clipsToBounds = false
        recommandCV.dataSource = self
        recommandCV.delegate = self
        popularCVTopConstant.constant = -10
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        shortRPCV.register(UINib(nibName: "RecipeProfile", bundle: nil), forCellWithReuseIdentifier: "RecipeProfile")
        popularCV.register(UINib(nibName: "RecipeProfile", bundle: nil), forCellWithReuseIdentifier: "RecipeProfile")
        recommandCV.register(UINib(nibName: "RecipeProfile", bundle: nil), forCellWithReuseIdentifier: "RecipeProfile")
        popularCVConstant.constant = (popularCV.frame.width / 2) * 4
        recommandCVConstant.constant = (recommandCV.frame.width / 2) * 4
        recommandCV.clipsToBounds = false
        shortViewConstant = shortViewConstant.setMultiplier(multiplier: 0.01)
        shortRPCV.isHidden = true
        popularCV.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    func setComponent(){
        self.myMenuBackV.backgroundColor = .clear
        self.registRecipeBtn.setGradient(color1: .gradient1, color2: .gradient2)
        self.registRecipeBtn.clipsToBounds = true
        self.menuV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabMenu(_ :))))
        self.myMenuBackV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideSideBar)))
        self.blurV.isHidden = true
    }
    
    func reloadCV(){
        self.recommandCV.reloadData()
        self.popularCV.reloadData()
        self.shortRPCV.reloadData()
        self.adBannerCV.reloadData()
    }
    
    func clearConstant(){
        Constant.videoUrls.removeAll()
        Constant.registThumbNail = nil
        Constant.registDetail.removeAll()
        Constant.registId = nil
        Constant.RECIPE_STAR = 4
        Constant.CURRENT_RECIPE = 0
        Constant.CURRENT_RECIPE_DETAIL = nil
        Constant.IS_BOOKMARK_PAGE = false
        Constant.PEOPLE_RECIPE_LIST = nil
        Constant.PUBLIC_RECIPE_LIST = nil
        Constant.CURRENT_MORE_RECIPE_TYPE = 0
        Constant.CURRENT_RECIPE_TYPE = 0
    }
}

// MARK: 컬렉션뷰 델리겟, 데이터소스 설정
extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItem(collectionView.tag)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView.tag == 0{
        return Cells(collectionView, cellForItemAt: indexPath)
//        }

    }
    
    // 셀 크기 화면 꽉차게
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        sizeOfCell(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tags = collectionView.tag
        
        
        if tags == 0{
            let cell = collectionView.cellForItem(at: indexPath) as! AdCell
            Constant.CURRENT_RECIPE = cell.adIdx
        }else if tags == 1{
            
        }else if tags == 2{
            let cell = collectionView.cellForItem(at: indexPath) as! RecipeProfileCell
            Constant.CURRENT_RECIPE = cell.recipeIdx
        }else{
            let cell = collectionView.cellForItem(at: indexPath) as! RecipeProfileCell
            Constant.CURRENT_RECIPE = cell.recipeIdx
        }
        self.performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    //광고뷰 셀 중앙정렬
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if collectionView.tag == 0{
            let totalCellWidth = self.view.frame.width * 4
            let leftInset = (self.view.frame.width - CGFloat(totalCellWidth))
            let rightInset = leftInset
            return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        }
        return UIEdgeInsets()
    }
    
}

// MARK: 컬렉션뷰 별 설정
extension MainVC{
    
    //셀 개수 반환
    func numberOfItem(_ tag: Int) -> Int{
        // 광고배너
        if tag == 0{
            if self.adBanner != nil{
                return self.adBanner!.count
            }else{
                return 0
            }
        }
        // 레시피 카테고리
        else if tag == 1{
            return 10
        }
        // 숏 레시피
        else if tag == 2{
            if self.shortRecipe != nil{
                return self.shortRecipe!.count
            }
            return 0
        }
        // 인기 레시피
        else if tag == 3{
            if self.hotRecipe != nil{
                return self.hotRecipe!.count
            }
            return 0
        }else{
            if self.recommendRecipe != nil{
                return self.recommendRecipe!.count
            }
            return 0
        }
    }
    
    //셀 반환
    func Cells(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        // 광고
        if collectionView.tag == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdBanner", for: indexPath) as! AdCell
//            cell.adImage.image = UIImage(named: "adtest")
            cell.adImage.kf.indicatorType = .activity
            if let getAd = self.adBanner{
                let item = getAd[indexPath.item]
                cell.adIdx = item.adverIdx
                cell.adImage.kf.setImage(with: URL(string:item.imagePath), placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil)
            }
            return cell
        }
        // 카테고리
        else if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Category", for: indexPath) as! CategoryCell
            cell.categoryImage.image = UIImage(named: "\(indexPath.item + 1)c")
            cell.categoryLabel.text = "\(category_list[indexPath.item])"
            return cell
        }
        //숏
        else if collectionView.tag == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeProfile", for: indexPath) as! RecipeProfileCell

            cell.rpImage.kf.indicatorType = .activity
            if let getShort = self.shortRecipe{
                let item = getShort[indexPath.item]
                
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
            }
            return cell
        }
        //핫
        else if collectionView.tag == 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeProfile", for: indexPath) as! RecipeProfileCell
            cell.smallMode()
            cell.layoutIfNeeded()
            cell.rpImage.kf.indicatorType = .activity
            if let getPeople = self.hotRecipe{
                let item = getPeople[indexPath.item]
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
                cell.rpHeartCount.text = "\(item.bookmarkCount)"
                cell.rpViewCount.text = "\(item.hits)"
            }
            return cell
        }
        
        //추천
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeProfile", for: indexPath) as! RecipeProfileCell
            cell.smallMode()
            cell.layoutIfNeeded()
            cell.rpImage.kf.indicatorType = .activity
            if let getPeople = self.recommendRecipe{
                let item = getPeople[indexPath.item]
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
                cell.rpHeartCount.text = "\(item.bookmarkCount)"
                cell.rpViewCount.text = "\(item.hits)"
            }
            return cell
        }
    }
    
    
    //광고 셀 크기 설정
    func sizeOfCell(_ collectionView: UICollectionView) -> CGSize{
        if collectionView.tag == 0{
            return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)
        }else if collectionView.tag == 1{
            return CGSize(width: collectionView.frame.width / 8 , height: collectionView.frame.height)
        }else if collectionView.tag == 2{
            var height1 = collectionView.frame.height
            if collectionView.frame.height > collectionView.frame.width{
                height1 = collectionView.frame.width
            }
            return CGSize(width: height1, height: height1)
        }else{
            return CGSize(width: (collectionView.frame.width / 2) - 5, height: (collectionView.frame.width / 2) - 5)
        }
    }
}

//MARK: 마이메뉴 테이블 관련
extension MainVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myMenuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! menuCell
        cell.menuLabel.text = myMenuList[indexPath.row]
        let backView = UIView()
        backView.backgroundColor = .buttonPink
        cell.selectedBackgroundView = backView
        return cell
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! menuCell
        cell.menuLabel.textColor = .buttonPink
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath){
        let cell = tableView.cellForRow(at: indexPath) as! menuCell
        cell.menuLabel.textColor = .white
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! menuCell
        cell.menuLabel.textColor = .buttonPink
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! menuCell
        cell.menuLabel.textColor = .white
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.maneTV.frame.height/5.9
    }
}

//MARK: API 요청 관련
extension MainVC{
    func didSuccessRequestPublicRecipe(result: GetPeopleRecipeResponse){
        self.adBanner = result.result
        self.shortRecipe = result.shorts
        self.hotRecipe = result.hots
        self.recommendRecipe = result.recommend
        Constant.PUBLIC_RECIPE_LIST = result
        self.reloadCV()
    }
    func didSuccessRequestPeopleRecipe(result: GetPeopleRecipeResponse){
//        self.adBanner = result.result
//        self.shortRecipe = result.shorts
//        self.hotRecipe = result.hots
//        self.recommendRecipe = result.recommend
        Constant.PEOPLE_RECIPE_LIST = result
//        self.reloadCV()
    }
    func failedToRequest(message: String){
        self.presentBottomAlert(message: message)
    }
}

//MARK: 사이드바 설정(애니메이션포함)
extension MainVC{
    func showSideBar(){
        self.blurV.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.myMenuV.frame = CGRect(x: 0, y: 0, width: self.myMenuV.frame.width, height: self.myMenuV.frame.height)
        },completion: nil)
    }
    @objc func hideSideBar(){
        DispatchQueue.main.async {
            self.blurV.isHidden = true
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.myMenuV.frame = CGRect(x: -self.myMenuV.frame.width, y: 0, width: self.myMenuV.frame.width, height: self.myMenuV.frame.height)
        },completion: nil)
    }
}



extension MainVC{
    @IBAction func unwindToMain(_ sender: UIStoryboardSegue) {
    }
}
