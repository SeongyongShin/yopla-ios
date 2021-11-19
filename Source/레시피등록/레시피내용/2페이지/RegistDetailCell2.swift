//
//  RegistDetailCell2.swift
//  yopla
//
//  Created by 신성용 on 2021/11/18.
//

import UIKit

class RegistDetailCell2: UICollectionViewCell {
    var currentDetailPage = 0
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var smallThumNailIV: UIImageView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var ingredientTF: UITextField!
    @IBOutlet weak var contentTV: UITextView!
    @IBOutlet weak var contentPlaceHolderLB: UILabel!
    @IBOutlet weak var nextBtn: BaseButton!
    @IBOutlet weak var prevBtn: BaseButton!
    var delegate: RegistRecipeDetailCellDelegate?
//    var imageDidSet = false
    override func awakeFromNib() {
        super.awakeFromNib()
        setComponent()
    }
    @IBAction func goToNext(_ sender: Any) {
        if self.titleTF.text!.count != 0 && self.ingredientTF.text!.count != 0 && self.contentTV.text!.count != 0{
            self.delegate?.setTempDetail(title: self.titleTF.text, content: self.contentTV.text, fileType: nil, ingredient: self.ingredientTF.text, image: nil, videoURL: nil)
            self.delegate?.setDetail()
        }else{
            self.delegate?.presentAlert(msg: "빈 칸을 채워주세요")
        }
    }
    @IBAction func goToPrev(_ sender: Any) {
        self.delegate?.getDetail()
    }
    
    
}
//MARK: 텍스트 관련
extension RegistDetailCell2: UITextViewDelegate{
    func setComponent(){
        contentTV.delegate = self
        self.nextBtn.layer.borderWidth = 2
        self.nextBtn.layer.borderColor = UIColor.white.cgColor

        self.prevBtn.layer.borderWidth = 2
        self.prevBtn.layer.borderColor = UIColor.white.cgColor
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0{
            self.contentPlaceHolderLB.text = "내용을 입력해주세요"
        }else{
            self.contentPlaceHolderLB.text = ""
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count == 0{
            self.contentPlaceHolderLB.text = "내용을 입력해주세요"
        }else{
            self.contentPlaceHolderLB.text = ""
        }
    }
}

extension RegistDetailCell2{
    func clear(){
        self.smallThumNailIV.image = UIImage()
        self.titleTF.text = ""
        self.ingredientTF.text = ""
        self.contentTV.text = ""
        self.contentPlaceHolderLB.text = "내용을 입력해주세요"
        self.prevBtn.isEnabled = true
    }
    
}
