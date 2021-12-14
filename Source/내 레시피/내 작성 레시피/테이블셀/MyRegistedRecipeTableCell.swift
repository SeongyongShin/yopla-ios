//
//  MyRegistedRecipeTableCell.swift
//  yopla
//
//  Created by 신성용 on 2021/11/25.
//

import UIKit

class MyRegistedRecipeTableCell: UITableViewCell {
    // 0: 내 작성 레시피
    // 1: 북마크 페이지
    var is_people = false
    var current_type = 0
    var delegate: BookMarkCellDelegate?
    @IBOutlet weak var recipeIV: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeCategory: UILabel!
    @IBOutlet weak var heartCount: UILabel!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var underLine: UIView!
    @IBOutlet var stars: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.recipeIV.layer.cornerRadius = 5
        self.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func modifyPressed(_ sender: Any) {
        if current_type == 0{
            delegate?.modifyPressed(recipeId: self.tag)
        }
    }
    
    @IBAction func xPressed(_ sender: Any) {
//        print(self.tag, self.current_type)
        delegate?.exitClicked(recipeId: self.tag, type: self.current_type)
    }
}
