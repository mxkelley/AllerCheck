//
//  Allergy.swift
//  AllerCheck
//
//  Created by Michael X Kelley on 4/25/19.
//  Copyright © 2019 Michael X Kelley. All rights reserved.
//

import Foundation
import Firebase

class Allergy {
    var allergy: String
    var postingUserID: String
    var documentID: String
    
    //MARK:- Dictionary Declarations
    var dictionary: [String: Any] {
        return ["allergy": allergy, "postingUserID": postingUserID, "documentID": documentID]
    }
    
    init(allergy: String, postingUserID: String, documentID: String) {
        self.allergy = allergy
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(allergy: "", postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let allergy = dictionary["allergy"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        
        self.init(allergy: allergy, postingUserID: postingUserID, documentID: "")
    }
    
    //MARK:- Save Data to Firebase Storage Function
    func saveData(completed: @escaping (Bool) -> ()) {
        print(allergy)
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
            let ref = db.collection("allergies").document(self.documentID)
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
            ref = db.collection("allergies").addDocument(data: dataToSave) { (error) in
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
