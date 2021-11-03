//
//  RecipeProfileCell.swift
//  yopla
//
//  Created by 신성용 on 2021/11/03.
//

import UIKit

class RecipeProfileCell: UICollectionViewCell {
    @IBOutlet weak var rpNickName: UILabel!
    @IBOutlet weak var rpProfile: RoundImageView!
    @IBOutlet weak var rpTitle: UILabel!
    @IBOutlet weak var rpImage: UIImageView!
    @IBOutlet weak var rpBookmark: UIImageView!
    @IBOutlet weak var rpHeartCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }

}
