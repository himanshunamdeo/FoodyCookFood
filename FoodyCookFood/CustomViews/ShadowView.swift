//
//  ShadowView.swift
//  FoodyCookFood
//
//  Created by MeTaLlOiD on 19/02/21.
//

import UIKit

class ShadowView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cardViewCornerRadius)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0);
        layer.shadowOpacity = 1
        layer.shadowPath = shadowPath.cgPath
        layer.masksToBounds = false
    }

}
