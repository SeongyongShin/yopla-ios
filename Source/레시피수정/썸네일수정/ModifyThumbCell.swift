//
//  ModifyThumbCell.swift
//  yopla
//
//  Created by 신성용 on 2021/12/06.
//

import UIKit

class ModifyThumbCell: UICollectionViewCell, UITextFieldDelegate {
    let test_category = ["한식", "양식", "일-중식", "아시안", "후식", "베이커리", "카페", "주류", "비건", "다이어트"]
    let test_times = ["정성을 들인 요리", "누구보다 빠른 요리", "20분 내외 요리", "40분 내외 요리", "1시간 내외 요리"]
    @IBOutlet weak var recipeTitle: UITextField!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTag: UITextField!
    @IBOutlet weak var recipeCategory: BaseButton!
    @IBOutlet weak var recipeTime: BaseButton!
    @IBOutlet weak var camera: UIImageView!
    var category_first = true
    var time_first = true
    var is_modified_img = false
    var fileUrl: String?
    var cell_section = 0
    var delegate: ModifyCell?
    var categoryDidSet:String?
    var timeDidSet:String?
//    var is_
    override func awakeFromNib() {
        super.awakeFromNib()
        recipeTitle.delegate = self
        recipeTitle.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        recipeTag.delegate = self
        recipeTag.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)

        recipeImage.isUserInteractionEnabled = true
        recipeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.selectImageFromGallery)))
        
        recipeCategory.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        recipeTime.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        recipeTitle.layer.cornerRadius = 5
        recipeTitle.layer.borderWidth = 1
        recipeTitle.layer.borderColor = UIColor.mainHotPink.cgColor
        
        recipeTag.layer.cornerRadius = 5
        recipeTag.layer.borderWidth = 1
        recipeTag.layer.borderColor = UIColor.mainHotPink.cgColor
    
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.mainHotPink.cgColor
        
        
        var item1: [UIAction] = []
        for i in test_category{
            item1.append(UIAction(title: "\(i)", image: UIImage(), handler: {_ in self.recipeCategory.setTitle("\(i)", for: .normal)
                self.categoryDidSet = "\(i)"
                self.delegate?.modifyData(section: 0, item: 0)
            }))
        }
        
        var item2: [UIAction] = []
        for i in test_times{
            item2.append(UIAction(title: "\(i)", image: UIImage(), handler: {_ in self.recipeTime.setTitle("\(i)", for: .normal)
                self.timeDidSet = "\(i)"
                self.delegate?.modifyData(section: 0, item: 0)
            }))
        }
        
        if #available(iOS 14.0, *) {
            recipeCategory.menu = UIMenu(title: "",
                                       image: UIImage(systemName: "heart"),
                                       identifier: nil,
                                       options: .displayInline,
                                       children: item1)
            recipeTime.menu = UIMenu(title: "",
                                       image: UIImage(systemName: "heart"),
                                       identifier: nil,
                                       options: .displayInline,
                                       children: item2)
        } else {
            return
        }
    }
    
    
    
    @objc func selectImageFromGallery(){
        delegate?.getPhoto(section: 0, item: 0)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.contentView.endEditing(true)
        return true
    }
    @objc func textFieldDidChange(_ sender: Any?) {
        delegate?.modifyData(section: 0, item: 0)
     }
}
