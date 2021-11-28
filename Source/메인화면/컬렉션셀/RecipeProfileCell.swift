//
//  RecipeProfileCell.swift
//  yopla
//
//  Created by 신성용 on 2021/11/03.
//

import UIKit

class RecipeProfileCell: BaseCollectionViewCell {
    var recipeIdx: Int = 0
    @IBOutlet weak var rpNickName: UILabel!
    @IBOutlet weak var rpProfile: RoundImageView!
    @IBOutlet weak var rpTitle: UILabel!
    @IBOutlet weak var rpImage: UIImageView!
    @IBOutlet weak var rpBookmark: UIImageView!
    @IBOutlet weak var rpBookmark1: UIImageView!
    @IBOutlet weak var rpHeartCount: UILabel!
    @IBOutlet weak var rpViewCount: UILabel!
    @IBOutlet weak var profileView: HalfRoundView1!
    
    @IBOutlet weak var profileSize: NSLayoutConstraint!
    @IBOutlet weak var bookmarkSize: NSLayoutConstraint!
    @IBOutlet weak var heartSize: NSLayoutConstraint!
    @IBOutlet weak var spaceSize: NSLayoutConstraint!
    @IBOutlet weak var eyeSize: NSLayoutConstraint!
    
    @IBOutlet weak var baseView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.baseView.layer.cornerRadius = 5
        self.baseView.layer.masksToBounds = false
        self.baseView.clipsToBounds = true
        rpBookmark1.isHidden = true
    }
    
    func smallMode(){
        rpBookmark.isHidden = true
        rpBookmark1.isHidden = false
        spaceSize.constant = 5
        profileSize.constant = 30
        rpProfile.layer.cornerRadius = 15
        bookmarkSize = bookmarkSize.setMultiplier(multiplier: 0.5)
        heartSize.constant = 13
        eyeSize.constant = 13
        rpTitle.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        rpNickName.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        rpHeartCount.font = UIFont.systemFont(ofSize: 9, weight: .bold)
        rpViewCount.font = UIFont.systemFont(ofSize: 9, weight: .bold)
    }
}
