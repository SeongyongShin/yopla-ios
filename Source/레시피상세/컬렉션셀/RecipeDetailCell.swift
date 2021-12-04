//
//  RecipeDetailCell.swift
//  yopla
//
//  Created by 신성용 on 2021/11/07.
//

import UIKit

class RecipeDetailCell: UICollectionViewCell {
    var fileType = "video"
    @IBOutlet weak var loadingV: UIView!
    @IBOutlet weak var indicatorV: UIActivityIndicatorView!
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var tonext: UIImageView!
    @IBOutlet weak var toprev: UIImageView!
}
