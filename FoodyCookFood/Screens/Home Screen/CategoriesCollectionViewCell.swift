//
//  CategoriesCollectionViewCell.swift
//  FoodyCookFood
//
//  Created by MeTaLlOiD on 15/02/21.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell, CollectionViewCellProtocol {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
    func updateUI(model: ModelDataForCell) {
        let model = model as! Category
        
        categoryImageView.fetchImage(url: model.strCategoryThumb)
        categoryName.text = model.strCategory
    }
    
    
}
