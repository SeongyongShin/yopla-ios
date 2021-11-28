//
//  CellProtocol.swift
//  yopla
//
//  Created by 신성용 on 2021/11/15.
//

import Foundation
import UIKit

protocol CellDelegate{
    func setimageInfo(image: UIImage)
    func getImageInfo()->UIImage
    func goToDetail()
    func setThumbNail(category: String, tag: String, time: String)
    func makeAlert(message: String)
}

protocol RegistRecipeDetailCellDelegate{
    func setimageInfo(image: UIImage)
    func getImageInfo()->UIImage
    func goToDetail()
    func setDetail()
    func setTempDetail(title: String?, content: String?, fileType: String?, ingredient: String?, image: UIImage?, videoURL: URL?)
    func getDetail()
//    func endEdit()
    func presentAlert(msg: String)
}

protocol BookMarkCellDelegate{
    func exitClicked(recipeId: Int, type: Int)
}

protocol RegistCellDelegate{
    func didSelectedImage()
}
