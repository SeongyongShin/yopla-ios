//
//  ModifyDetailCell.swift
//  yopla
//
//  Created by 신성용 on 2021/12/06.
//

import UIKit

class ModifyDetailCell: UICollectionViewCell, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UITextField!
    @IBOutlet weak var recipeIngredient: UITextField!
    @IBOutlet weak var recipeContent: UITextView!
    @IBOutlet weak var camera: UIImageView!
    var is_modified_img = false
    var fileType: String?
    var fileUrl: String?
    var cell_section = 1
    var cell_item = 0
    var delegate: ModifyCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        recipeTitle.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        recipeIngredient.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        recipeContent.delegate = self
        recipeTitle.delegate = self
        recipeIngredient.delegate = self
        
        recipeImage.isUserInteractionEnabled = true
        recipeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.selectImageFromGallery)))
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.mainHotPink.cgColor
        self.recipeImage.layer.borderColor = UIColor.mainHotPink.cgColor
        self.recipeImage.layer.borderWidth = 1
        self.recipeImage.layer.cornerRadius = 5
        self.recipeImage.clipsToBounds = true
    }
    @objc func selectImageFromGallery(){
        delegate?.getPhoto(section: cell_section, item: cell_item)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.contentView.endEditing(true)
        return true
    }
    @objc func textFieldDidChange(_ sender: Any?) {
        delegate?.modifyData(section: 1, item: self.cell_item)
     }
    func textViewDidChange(_ textView: UITextView) {
        delegate?.modifyData(section: 1, item: self.cell_item)
    }
}
