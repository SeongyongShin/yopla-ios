//
//  ReviewCell.swift
//  yopla
//
//  Created by 신성용 on 2021/11/24.
//

import UIKit

class ReviewCell: UITableViewCell {
    var recipeId: Int?
    @IBOutlet weak var profileImage: RoundImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var created_at: UILabel!
    @IBOutlet var stars: [UIImageView]!
    var delagete: ReportCellDelegate?
    @IBOutlet weak var report1: UIButton!
    @IBOutlet weak var report2: UIImageView!
    @IBOutlet weak var report3: UILabel!
    
    @IBAction func reportPressed(_ sender: Any) {
        if !Constant.IS_GUEST{
            delagete?.report(id: self.tag)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        if Constant.IS_GUEST{
            report1.isHidden = true
            report2.image = UIImage()
            report3.text = ""
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
