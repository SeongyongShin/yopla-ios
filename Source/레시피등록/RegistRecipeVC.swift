//
//  RegistRecipeVC.swift
//  yopla
//
//  Created by 신성용 on 2021/11/11.
//

import UIKit
import AVFoundation

class RegistRecipeVC: BaseViewController {
    var current_page = 0
    @IBOutlet weak var backBtn1: UIButton!
    @IBOutlet weak var backBtn2: UIButton!
    @IBOutlet weak var recipeTitle: UITextField!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var topbar: UIView!
    @IBOutlet weak var topbar2: UIView!
    var tempThumbNail = ThumbPage()
    var thumbImage: UIImage = UIImage()
    var thumImage_set = false
    var keyboardHeight:CGFloat = 0
    var keyboardShow = false
    let max_page = 2
    @IBOutlet weak var registCV: UICollectionView!
    @IBOutlet weak var registCVConstant: NSLayoutConstraint!
    @IBOutlet weak var registCVConstant2: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponent()
    }
    override func viewWillAppear(_ animated: Bool) {

        // 키보드리스너 추가
        self.addKeyboardNotifications()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        // 키보드리스너 추가
        self.removeKeyboardNotifications()
        
    }
    @IBAction func homePressed(_ sender: Any) {
        self.makeTabBarRootVC("MainTabBar")
    }
    @IBAction func backPressed(_ sender: Any) {
        if current_page == 0{
            self.makeTabBarRootVC("MainTabBar")
        }else{
            DispatchQueue.main.async {
            self.registCV.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
    
}

//MARK: 컴포넌트 설정
extension RegistRecipeVC{
    func setComponent(){
        self.topbar.backgroundColor = .white
        self.topbar2.backgroundColor = .white
        self.homeBtn.isHidden = true
        self.homeImage.isHidden = true
        for i in 1...2{
            registCV.register(UINib(nibName: "RegistCell\(i)", bundle: nil), forCellWithReuseIdentifier: "RegistCell\(i)")
        }
        registCV.delegate = self
        registCV.dataSource = self
        self.recipeTitle.delegate = self
    }
}

//MARK: 컬렉션뷰설정
extension RegistRecipeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max_page
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegistCell\(indexPath.item + 1)", for: indexPath)
        if indexPath.item == 0{
            let cell = cell as! RegistCell1
            cell.delegate = self
            return cell
        }else if indexPath.item == 1{
            let cell = cell as! RegistCell2
            cell.delegate = self
            return cell
        }
        
        
        return cell as! RegistCell1
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(current_page)
        if indexPath.item == 1{
            current_page = 1
            backBtn1.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            let cell = cell as! RegistCell2
            cell.imageView.image = self.thumbImage
            self.topbar.backgroundColor = .mainBackground
            self.topbar2.backgroundColor = .mainBackground
            self.homeBtn.isHidden = false
            self.homeImage.isHidden = false
        }else{
            current_page = 0
            backBtn1.setImage(UIImage(systemName: "house.fill"), for: .normal)
            let cell = cell as! RegistCell1
            cell.delegate2 = self
            self.topbar.backgroundColor = .white
            self.topbar2.backgroundColor = .white
            self.homeBtn.isHidden = true
            self.homeImage.isHidden = true
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == 0{
            current_page = 1
            self.topbar.backgroundColor = .mainBackground
            self.topbar2.backgroundColor = .mainBackground
            self.homeBtn.isHidden = false
            self.homeImage.isHidden = false
        }else{
            current_page = 0
            self.topbar.backgroundColor = .white
            self.topbar2.backgroundColor = .white
            self.homeBtn.isHidden = true
            self.homeImage.isHidden = true
        }
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
}

//MARK: 키보드만큼 올리기
extension RegistRecipeVC{
    
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
//            self.view.frame.origin.y -= self.keyboardHeight
//            self.view.layoutIfNeeded()
            self.registCV.frame.origin.y -= self.keyboardHeight
            self.registCVConstant.constant += self.keyboardHeight
            self.registCVConstant2.constant = -self.keyboardHeight
            self.registCV.layoutIfNeeded()
            keyboardShow = true
        }
    }
    
    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillHide(_ noti: NSNotification){
        
        if !keyboardShow{
            //키보드가 떠있지 않으면
            return
        }
        self.registCV.frame.origin.y = 0
        self.registCVConstant.constant = 0
        self.registCVConstant2.constant = 0
        self.registCV.layoutIfNeeded()
//        self.view.frame.origin.y += self.keyboardHeight
//        self.view.layoutIfNeeded()
        
        keyboardShow = false
    }
}

extension RegistRecipeVC: CellDelegate{

    func setimageInfo(image: UIImage){
        thumbImage = image
        thumImage_set = true
    }
    
    func getImageInfo()->UIImage{
        return thumbImage
    }
    
    func goToDetail(){
        if recipeTitle.text == nil || recipeTitle.text == ""{
            self.presentBottomAlert(message: "제목을 입력해주세요")
            return
        }else if !thumImage_set{
            self.presentBottomAlert(message: "썸네일을 적용해주세요")
            return
        }
        
        tempThumbNail.title = recipeTitle.text

        Constant.tempThumbNails = tempThumbNail
        self.performSegue(withIdentifier: "goToRegistRecipe", sender: self)
    }
    
    func setThumbNail(category: String, tag: String, time: String) {
        tempThumbNail.category = category
        tempThumbNail.tag = tag.components(separatedBy: " ")
        tempThumbNail.image = self.thumbImage
    }
    
    func makeAlert(message: String){
        self.presentBottomAlert(message: message)
    }
    
}

extension RegistRecipeVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension RegistRecipeVC: RegistCellDelegate{
    func didSelectedImage() {
        DispatchQueue.main.async {
        self.registCV.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    
}

extension RegistRecipeVC{
    
    @IBAction func unwindToThumnail(_ sender: UIStoryboardSegue) {

    }
}
