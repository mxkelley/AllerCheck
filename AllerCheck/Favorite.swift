//
//  Favorite.swift
//  AllerCheck
//
//  Created by Michael X Kelley on 4/26/19.
//  Copyright © 2019 Michael X Kelley. All rights reserved.
//

import Foundation
import Firebase

class Favorite {
    var brandName: String
    var productName: String
    var productDescription: String
    var productIngredients: String
    var postingUserID: String
    var documentID: String
    
    //MARK:- Dictionary Declarations
    var dictionary: [String: Any] {
        return ["brandName": brandName, "productName": productName, "productDescription": productDescription, "productIngredients": productIngredients, "postingUserID": postingUserID, "documentID": documentID]
    }
    
    init(brandName: String, productName: String, productDescription: String, productIngredients: String, postingUserID: String, documentID: String) {
        self.brandName = brandName
        self.productName = productName
        self.productDescription = productDescription
        self.productIngredients = productIngredients
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(brandName: "", productName: "", productDescription: "", productIngredients: "", postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let brandName = dictionary["brandName"] as! String? ?? ""
        let productName = dictionary["productName"] as! String? ?? ""
        let productDescription = dictionary["productDescription"] as! String? ?? ""
        let productIngredients = dictionary["productIngredients"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        
        self.init(brandName: brandName, productName: productName, productDescription: productDescription, productIngredients: productIngredients, postingUserID: postingUserID, documentID: "")
    }
    
    //MARK:- Save Data to Firebase Storage Function
    func saveData(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        //Grab the userID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completed(false)
        }
        self.postingUserID = postingUserID
        //Create the dictionary representing the data we want to save
        let dataToSave = self.dictionary
        //If we HAVE saved a record, we'll have a documentID
        if self.documentID != "" {
            let ref = db.collection("favorites").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: Updating document \(self.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    completed(true)
                }
            }
        } else {
            var ref: DocumentReference? = nil //let firestore create the new documentID
            ref = db.collection("favorites").addDocument(data: dataToSave) { (error) in
                if let error = error {
                    print("*** ERROR: Creating new document \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ New document created with ref ID \(ref?.documentID ?? "unknown")")
                    self.documentID = ref!.documentID
                    completed(true)
                }
            }
        }
    }
}
