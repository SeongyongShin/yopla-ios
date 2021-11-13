//
//  RegistCell2.swift
//  yopla
//
//  Created by 신성용 on 2021/11/11.
//

import UIKit

class RegistCell2: UICollectionViewCell{
    let test_category = ["한식","중식","양식","기타"]
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextBtn: BaseButton!
    @IBOutlet weak var categoryBtn1: BaseButton!
    @IBOutlet weak var categoryBtn2: BaseButton!
    var count = 0
    var delegate: CellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView?.image = self.delegate?.getImageInfo()
        nextBtn.layer.borderColor = UIColor.white.cgColor
        nextBtn.layer.borderWidth = 2
        categoryBtn1.clipsToBounds = true
        categoryBtn2.clipsToBounds = true
        categoryBtn1.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        categoryBtn2.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
//        let favorite = UIAction(title: "api적용되면 바꿀것", image: UIImage(), handler: {_ in print("test") })
        var favorite: [UIAction] = []
        for i in test_category{
            favorite.append(UIAction(title: "\(i)", image: UIImage(), handler: {_ in self.categoryBtn1.setTitle("\(i)", for: .normal) }))
        }
        if #available(iOS 14.0, *) {
            categoryBtn1.menu = UIMenu(title: "",
                                       image: UIImage(systemName: "heart"),
                                       identifier: nil,
                                       options: .displayInline,
                                       children: favorite)
        } else {
            return
        }
    }
    // 외부 터치 시 키보드내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.contentView.endEditing(true)
    }
}
