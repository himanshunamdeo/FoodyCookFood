//
//  CardView.swift
//  FoodyCookFood
//
//  Created by MeTaLlOiD on 19/02/21.
//

import UIKit

class CardView: UIView {

    override func layoutSubviews() {
        layer.cornerRadius = 10
        clipsToBounds = true
    }
     
    public func giveUpRoundedCorners() {
        layer.cornerRadius = 0
    }
    
    public func restoreOriginalSettings() {
        layoutSubviews()
    }
    
    
}
