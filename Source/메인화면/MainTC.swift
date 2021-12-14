//
//  MainTC.swift
//  yopla
//
//  Created by 신성용 on 2021/11/28.
//

import UIKit

class MainTC: UITabBarController, performSegues {


    override func viewDidLoad() {
        super.viewDidLoad()
        let VCList = self.viewControllers!
        for i in 0...3{
            if i == 0{
                let VC = VCList[i] as! MainVC
                VC.mainDelegate = self
            }else if i == 1{
                let VC = VCList[i] as! SearchRecipeVC
                VC.searchDelegate = self
            }else if i == 2{
                let VC = VCList[i] as! MyRegistedRecipeVC
                VC.myRegistedDelegate = self
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Constant.USER_IDX == 12{
            Constant.IS_GUEST = true
        }
    }
    func goToVC(_ identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: self)
    }
    
    
}

class TabBarWithCorners: UITabBar {
    @IBInspectable var color: UIColor?
    @IBInspectable var radii: CGFloat = 25.0

    private var shapeLayer: CALayer?

    override func draw(_ rect: CGRect) {
        addShape()
    }

    private func addShape() {
        let shapeLayer = CAShapeLayer()

        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.gray.withAlphaComponent(0.1).cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0   , height: -3);
        shapeLayer.shadowOpacity = 0.2
        shapeLayer.shadowPath =  UIBezierPath(roundedRect: bounds, cornerRadius: radii).cgPath
        

        if let oldShapeLayer = self.shapeLayer {
            layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }

    private func createPath() -> CGPath {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radii, height: 0.0))

        return path.cgPath
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.isTranslucent = true
        var tabFrame = self.frame
        tabFrame.size.height = 65 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? CGFloat.zero)
        tabFrame.origin.y = self.frame.origin.y + ( self.frame.height - 65 - (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? CGFloat.zero))
        self.layer.cornerRadius = 20
        self.frame = tabFrame
        self.items?.forEach({ $0.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -5.0) })
    }

}
