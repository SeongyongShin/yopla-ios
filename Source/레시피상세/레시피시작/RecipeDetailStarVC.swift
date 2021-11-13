//
//  RecipeDetailStarVC.swift
//  yopla
//
//  Created by 신성용 on 2021/11/09.
//

import UIKit

class RecipeDetailStarVC: BaseViewController {

    @IBOutlet weak var recipeBookMarkBtn: BaseButton!
    @IBOutlet var stars: [UIImageView]!
    @IBOutlet weak var starScore: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponent()
        setStarTapGesture()
    }

}

//MARK: 터치이벤트 설정
extension RecipeDetailStarVC{
    // 별점 선택
    @objc func setStar(_ sender: UITapGestureRecognizer){
        for i in sender.view!.tag...4{
            self.stars[i].image = UIImage(systemName: "star")
        }
        for i in 0...sender.view!.tag{
            self.stars[i].image = UIImage(systemName: "star.fill")
        }
        starScore.text = "\(sender.view!.tag + 1).0"
    }
    
}

//MARK: 컴포넌트들 설정
extension RecipeDetailStarVC{
    // 컴포넌트 설정
    func setComponent(){
        self.recipeBookMarkBtn.setTitleColor(.black, for: .normal)
    }
    func setStarTapGesture(){
        for i in stars{
            i.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setStar)))
            i.isUserInteractionEnabled = true
        }
    }
}


extension RecipeDetailStarVC{
    @IBAction func unwindToStar(_ sender: UIStoryboardSegue) {
        
    }
}
