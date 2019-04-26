//
//  Favorites.swift
//  AllerCheck
//
//  Created by Michael X Kelley on 4/26/19.
//  Copyright © 2019 Michael X Kelley. All rights reserved.
//

import Foundation
import Firebase

class Favorites {
    
    var favoritesArray: [Favorite] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    //MARK:- Load Data from Firebase Storage Function
    func loadData(completed: @escaping () -> ()) {
        db.collection("favorites").addSnapshotListener{ (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: Adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.favoritesArray = []
            
            //there are querySnapshot.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents {
                let favorite = Favorite(dictionary: document.data())
                _ = Firestore.firestore()
                //Grab the userID
                guard let currentUser = (Auth.auth().currentUser?.uid) else {
                    print("*** ERROR: Could not save data because we don't have a valid postingUserID")
                    return
                }
                if favorite.postingUserID == currentUser {
                    favorite.documentID = document.documentID
                    self.favoritesArray.append(favorite)
                }
                
            }
            completed()
        }
    }
}
