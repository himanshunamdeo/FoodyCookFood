//
//  ItemsCollectionViewCell.swift
//  FoodyCookFood
//
//  Created by MeTaLlOiD on 15/02/21.
//

import UIKit


class ItemsCollectionViewCell: UICollectionViewCell, CollectionViewCellProtocol {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    
    func updateUI(model: ModelDataForCell) {
        let model = model as! Meal
        if let mealThumb = model.strMealThumb,
           let mealTitle = model.strMeal {
            itemImageView.fetchImage(url: mealThumb.appending("/preview"))
            itemName.text = mealTitle
        }
        
    }
}

extension UIImageView {
    
    func fetchImage(url: String) {
        print("==============\(url)")
        let session = URLSession.shared
        
        session.dataTask(with: URL(string: url)!) { (data, response, error) in
            print("Image urls response recieved: \(response as! HTTPURLResponse)")
            if let error = error {
                print("Can't download image from \(url): \(error)")
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}
