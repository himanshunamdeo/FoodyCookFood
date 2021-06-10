//
//  Categories.swift
//  FoodyCookFood
//
//  Created by MeTaLlOiD on 15/02/21.
//

import Foundation

struct CategoriesDict: Codable {
    var categories: [Category]
}

struct Category: Codable, ModelDataForCell {
    
    var idCategory: String = ""
    var strCategory: String = ""
    var strCategoryThumb: String = ""
    var strCategoryDescription: String = ""
    
}
