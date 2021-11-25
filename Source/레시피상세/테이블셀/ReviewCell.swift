//
//  ReviewCell.swift
//  yopla
//
//  Created by 신성용 on 2021/11/24.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var profileImage: RoundImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var created_at: UILabel!
    @IBOutlet var stars: [UIImageView]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
