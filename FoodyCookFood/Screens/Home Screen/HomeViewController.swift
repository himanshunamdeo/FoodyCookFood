//
//  HomeViewController.swift
//  FoodyCookFood
//
//  Created by MeTaLlOiD on 15/02/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var nothingView: UIView!
    @IBOutlet weak var infoErrorImageView: UIImageView!
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    
    private var itemsArray: [Meal]?
    private var categoriesArray: [Category]?
    private let group = DispatchGroup()
    private var collectionViewLineSpacing: CGFloat = 0.0
    private var itemCellWidth: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateData()
        
    }

    private func populateData() {
        
//        mainContentView.isHidden = true
        
        fetchItems()
        fetchCategories()
        
        group.notify(queue: .main) {
            self.mainContentView.isHidden = false
            self.itemsCollectionView.reloadData()
            self.categoriesCollectionView.reloadData()
        }
    }
    
    private func fetchItems() {
        let itemsActivityIndicator = UIActivityIndicatorView(frame: itemsCollectionView.frame)
        itemsActivityIndicator.style = .large
        view.addSubview(itemsActivityIndicator)
        itemsActivityIndicator.bringSubviewToFront(mainContentView)
        itemsActivityIndicator.startAnimating()
        let manager = NetworkManager(url: .RandomMeals(url: randomMealURL, method: "get"), parameters: nil)
        
        group.enter()
        manager.fetchData { (result: Result<MealDict, Error>) in
            DispatchQueue.main.async {
                itemsActivityIndicator.stopAnimating()
            }
            
            switch result {
            
            case .success(let meals):
                self.itemsArray = meals.meals
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
            self.group.leave()
        }
    }
    
    private func fetchCategories() {
        let categoriesActivityIndicator = UIActivityIndicatorView(frame: categoriesCollectionView.frame)
        categoriesActivityIndicator.style = .large
        view.addSubview(categoriesActivityIndicator)
        categoriesActivityIndicator.startAnimating()
        
        group.enter()
        NetworkManager(url: .MealCategories(url: mealCategoriesURL, method: "get"), parameters: nil).fetchData { (result: Result<CategoriesDict, Error>) in
            DispatchQueue.main.async {
                categoriesActivityIndicator.stopAnimating()
            }
            
            switch result {
            
            case .success(let categories):
                
                self.categoriesArray = categories.categories
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
            
            self.group.leave()
        }
    }
    
    @IBAction func searchBarButtonAction(_ sender: Any) {
        
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == itemsCollectionView {
            if let items = self.itemsArray {
                return items.count
            }
        }
        
        if collectionView == categoriesCollectionView {
            if let categories = self.categoriesArray {
                return categories.count
            }
        }
        
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let isItemsCollectionView = collectionView == itemsCollectionView
        var cell: UICollectionViewCell?
        
        if collectionView == itemsCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifires.ItemsCollectionViewCell.rawValue, for: indexPath) as! ItemsCollectionViewCell
        }
        
        if collectionView == categoriesCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifires.CategoriesCollectionViewCell.rawValue, for: indexPath) as! CategoriesCollectionViewCell
        }
        
        var tempArray = [Any]()
        if collectionView == itemsCollectionView {
            if let itemsArray = itemsArray {
                tempArray = itemsArray
            }
        } else {
            if let categoriesArray = categoriesArray {
                tempArray = categoriesArray
            }
        }
        if tempArray.count > 0 {
            (cell as! CollectionViewCellProtocol).updateUI(model: tempArray[indexPath.row] as! ModelDataForCell)
        }
        
        
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.itemsCollectionView {
            return getCellSize(heightMultiplier: 0.45, widthMultiplier: 0.2)
        }
        
        return getCellSize(heightMultiplier: 0.8571, widthMultiplier: 0.6908)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == itemsCollectionView {
            return collectionViewLineSpacing
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        if collectionView == itemsCollectionView {
            let collectionViewWidth = collectionView.frame.size.width
            let cellWidth = itemCellWidth
            let spacing = (collectionViewWidth / 2) - (cellWidth / 2)
            collectionViewLineSpacing = spacing * 2
            return UIEdgeInsets(top: 0, left: CGFloat(spacing), bottom: 0, right: 0)
        }
        
        return UIEdgeInsets.zero
        
    }
    
    
    func getCellSize(heightMultiplier: CGFloat, widthMultiplier: CGFloat) -> CGSize {
        let height = screenH - (screenH * heightMultiplier)
        let width = screenW - (screenW * widthMultiplier)
        itemCellWidth = width
        return CGSize(width: width, height: height)
    }
    
}

extension HomeViewController: UITextFieldDelegate {
    
}

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
