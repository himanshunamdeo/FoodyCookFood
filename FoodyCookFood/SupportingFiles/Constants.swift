//
//  Constants.swift
//  FoodyCookFood
//
//  Created by MeTaLlOiD on 15/02/21.
//

import Foundation
import UIKit

let randomMealURL = "https://www.themealdb.com/api/json/v1/1/random.php"
let mealCategoriesURL = "https://www.themealdb.com/api/json/v1/1/categories.php"
let searchURL = "https://www.themealdb.com/api/json/v1/1/search.php"

enum CellIdentifires: String {
    case ItemsCollectionViewCell = "ItemsCollectionViewCell"
    case CategoriesCollectionViewCell = "CategoriesCollectionViewCell"
}

enum NetworkURLs {
    case RandomMeals(url: String, method: String)
    case MealCategories(url: String, method: String)
    case SearchByName(url: String, method: String)
}

let cardViewCornerRadius: CGFloat = 10.0
let screenH = UIScreen.main.bounds.height
let screenW = UIScreen.main.bounds.width
