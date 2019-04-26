//
//  ScanResponseViewController.swift
//  AllerCheck
//
//  Created by Michael X Kelley on 4/24/19.
//  Copyright © 2019 Michael X Kelley. All rights reserved.
//

import UIKit

class ScanResponseViewController: UIViewController {

    @IBOutlet weak var safetyImage: UIImageView!
    @IBOutlet weak var safetyLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var addToFavoritesButton: UIButton!
    
    var food = FoodUPCs()
    var myAllergies = MyAllergies()
    let defaultsData = UserDefaults.standard
    
    var favorite = Favorite()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if defaultsData.string(forKey: "ingredients") != "" {
            brandLabel.text = defaultsData.string(forKey: "brand")
            nameLabel.text = defaultsData.string(forKey: "name")
            descriptionTextView.text = defaultsData.string(forKey: "description")
            ingredientsTextView.text = defaultsData.string(forKey: "ingredients")
            if defaultsData.bool(forKey: "doNotEat") == true {
                safetyImage.image = UIImage(named: "Unsafe")
                safetyLabel.text = "🛑 DO NOT EAT!"
                safetyLabel.textColor = UIColor.red
                addToFavoritesButton.isHidden = true
            } else if defaultsData.bool(forKey: "doNotEat") == false {
                safetyImage.image = UIImage(named: "Safe")
                safetyLabel.text = "✅ Safe To Eat"
                safetyLabel.textColor = UIColor.green
                addToFavoritesButton.isHidden = false
            }
        } else {
            showUPCAlert(title: "No Ingredients Found", message: "Unable to find ingredients for this product.")
            safetyImage.image = UIImage(named: "Unsafe")
            safetyLabel.text = "🛑 DO NOT EAT!"
            safetyLabel.textColor = UIColor.red
            addToFavoritesButton.isHidden = true
            brandLabel.text = defaultsData.string(forKey: "brand")
            nameLabel.text = defaultsData.string(forKey: "name")
            descriptionTextView.text = defaultsData.string(forKey: "description")
            ingredientsTextView.text = defaultsData.string(forKey: "ingredients")
        }
        
    }
    
    func showUPCAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.tabBarController?.selectedIndex = 1
            self.defaultsData.set(0, forKey: "upc")
            self.defaultsData.set("", forKey: "brand")
            self.defaultsData.set("", forKey: "name")
            self.defaultsData.set("", forKey: "description")
            self.defaultsData.set("", forKey: "ingredients")
        })
        alertController.addAction(defaultAction)
        view.addSubview(alertController.view)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        tabBarController?.selectedIndex = 1
    }
    
    //MARK:- Adding Response to Favorites
    @IBAction func addToFavoritesButtonPressed(_ sender: UIButton) {
        if let brandDefault = self.defaultsData.string(forKey: "brand") {
            self.favorite.brandName = brandDefault
        }
        if let nameDefault = defaultsData.string(forKey: "name") {
            favorite.productName = nameDefault
        }
        if let descriptionDefault = defaultsData.string(forKey: "description") {
            favorite.productDescription = descriptionDefault
        }
        if let ingredientsDefault = defaultsData.string(forKey: "ingredients") {
            favorite.productIngredients = ingredientsDefault
        }
        
        favorite.saveData { success in
            if success {
                self.tabBarController?.selectedIndex = 4
            } else {
                print("Can't segue because of the error")
            }
        }
    }
    
    
    
}
