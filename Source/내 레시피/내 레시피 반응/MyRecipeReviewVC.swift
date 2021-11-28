//
//  MyRecipeReviewVC.swift
//  yopla
//
//  Created by 신성용 on 2021/11/25.
//

import UIKit
import Kingfisher

class MyRecipeReviewVC: BaseViewController,UITableViewDelegate, UITableViewDataSource {
    
    lazy var dataManager: GetRecipeReviewDataManager = GetRecipeReviewDataManager()
    @IBOutlet weak var reviewTv: UITableView!
    
    var reviewList: [GetRecipeReviewResult]?
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTv.tableFooterView = UIView()
        reviewTv.delegate = self
        reviewTv.dataSource = self
        reviewTv.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        dataManager.getMyRecipeReview(delegate: self)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reviewList != nil{
            return reviewList!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewCell
        cell.selectedBackgroundView = UIView()
        if let review = reviewList{
            let item = review[indexPath.row]
            
            if item.userPI != nil{
                cell.profileImage.kf.setImage(with: URL(string:item.userPI!), placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil)
            }
            
            cell.nickName.text = item.userNickName
            cell.content.text = item.content
            cell.created_at.text = "From. " + "\(item.recipeName!)"
            
            for i in 0 ... 4{
                cell.stars[i].image = UIImage(systemName: "star")
            }
            
            if item.reviewScore != 5{
                for i in 0 ... item.reviewScore{
                    cell.stars[i].image = UIImage(systemName: "star.fill")
                }
            }else{
                for i in 0 ... 4{
                    cell.stars[i].image = UIImage(systemName: "star.fill")
                }
            }
            
            
        }
        return cell
    }
    
    func didSuccessGetReview(result: [GetRecipeReviewResult]?){
        if result != nil{
            reviewList = result!
            self.reviewTv.reloadData()
        }
    }
    func failedToRequest(message: String){
        self.presentBottomAlert(message: message)
    }
}
