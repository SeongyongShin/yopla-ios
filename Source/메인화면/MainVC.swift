//
//  MainVC.swift
//  yopla
//
//  Created by 신성용 on 2021/11/02.
//

import UIKit

class MainVC: BaseViewController {
    @IBOutlet weak var menuV: UIView!
    @IBOutlet weak var searchV: UIView!
    @IBOutlet weak var editV: UIView!
    @IBOutlet weak var heartV: UIView!
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
        Constant.videoUrls.removeAll()
        Constant.registThumbNail = nil
        Constant.registDetail.removeAll()
        Constant.registId = nil
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
            
        }
        //검색버튼
        else if tag == 1{
            self.performSegue(withIdentifier: "goSearchFromMain", sender: self)
        }
        //edit 버튼
        else if tag == 2{
            
        }
        //heart 버튼
        else{
            
        }
    }
}

//MARK: 터치 시 함수
extension MainVC{
    // 라벨 터치 시 호출함수
    @objc func changeView(_ sender: UITapGestureRecognizer){
        if sender.view?.tag == 0 && current_tab != 0{
            UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            changeViewSubFunc(sender.view!.tag, labelEnabled: true, indicatorX: 0)
            shortViewConstant = shortViewConstant.setMultiplier(multiplier: 0.01)
            popularCVTopConstant.constant = -10
            shortRPCV.isHidden = true
//            self.layoutIfNeeded()
            
        }else if sender.view?.tag == 1 && current_tab != 1{
            UserDefaults.standard.set(true, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            changeViewSubFunc(sender.view!.tag, labelEnabled: false, indicatorX: recipeIndicator.frame.width)
            popularCVTopConstant.constant = 30
            shortViewConstant = shortViewConstant.setMultiplier(multiplier: 0.4)
            shortRPCV.isHidden = false
//            self.layoutIfNeeded()
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
        adBannerCV.dataSource = self
        adBannerCV.delegate = self
        categoryCV.dataSource = self
        categoryCV.delegate = self
        shortRPCV.dataSource = self
        shortRPCV.delegate = self
        shortRPCV.clipsToBounds = false
        popularCV.dataSource = self
        popularCV.delegate = self
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
        self.registRecipeBtn.setGradient(color1: .gradient1, color2: .gradient2)
        self.registRecipeBtn.clipsToBounds = true
        self.menuV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabMenu(_ :))))
        self.searchV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabMenu(_ :))))
        self.editV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabMenu(_ :))))
        self.heartV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabMenu(_ :))))
    }
}

// MARK: 컬렉션뷰 델리겟, 데이터소스 설정
extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItem(collectionView.tag)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView.tag == 0{
        return adBannerCell(collectionView, cellForItemAt: indexPath)
//        }

    }
    
    // 셀 크기 화면 꽉차게
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        sizeOfCell(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
            return 4
        }
        // 레시피 카테고리
        else if tag == 1{
            return 10
        }
        // 숏 레시피
        else if tag == 2{
            return 5
        }
        // 인기 레시피
        else{
            return 8
        }
    }
    
    //광고 셀 반환
    func adBannerCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if collectionView.tag == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdBanner", for: indexPath) as! AdCell
            cell.adImage.image = UIImage(named: "adtest")
            return cell
        }else if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Category", for: indexPath) as! CategoryCell
            cell.categoryImage.image = UIImage(named: "\(indexPath.item + 1)c")
            cell.categoryLabel.text = "\(category_list[indexPath.item])"
            return cell
        }else if collectionView.tag == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeProfile", for: indexPath) as! RecipeProfileCell
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeProfile", for: indexPath) as! RecipeProfileCell
            cell.smallMode()
            cell.layoutIfNeeded()
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

extension MainVC{
    @IBAction func unwindToMain(_ sender: UIStoryboardSegue) {
    }
}
