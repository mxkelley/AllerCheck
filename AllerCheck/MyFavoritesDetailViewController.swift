//
//  MyFavoritesDetailViewController.swift
//  AllerCheck
//
//  Created by Michael X Kelley on 4/24/19.
//  Copyright © 2019 Michael X Kelley. All rights reserved.
//

import UIKit
import Firebase

class MyFavoritesDetailViewController: UIViewController {

    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var deleteFavoriteButton: UIButton!
    
    var favorite: Favorite!
    
    //MARK:- ViewDidLoad Setting Up ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if favorite == nil {
            favorite = Favorite()
            deleteFavoriteButton.isHidden = true
        }
        brandLabel.text = favorite.brandName
        productLabel.text = favorite.productName
        descriptionTextView.text = favorite.productDescription
        ingredientsTextView.text = favorite.productIngredients
        
    }
    
    //MARK:- Deleting Data from Firebase Storage Using Delete Button
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let db = Firestore.firestore()
        db.collection("favorites").document(favorite.documentID).delete() { error in
            if let error = error {
                print("😡 ERROR: Deleting review documentID \(self.favorite.documentID) \(error.localizedDescription)")
            } else {
                let favorites = Favorites()
                favorites.loadData {
                    let isPresentingInAddMode = self.presentingViewController is UINavigationController
                    if isPresentingInAddMode {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }
            }
        }
    }
    
}
