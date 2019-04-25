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
    let defaultsData = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if defaultsData.string(forKey: "ingredients") != "" {
            brandLabel.text = defaultsData.string(forKey: "brand")
            nameLabel.text = defaultsData.string(forKey: "name")
            descriptionTextView.text = defaultsData.string(forKey: "description")
            ingredientsTextView.text = defaultsData.string(forKey: "ingredients")
        } else {
            showUPCAlert(title: "No Ingredients Found", message: "Unable to find ingredients for this product.")
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
    
}
