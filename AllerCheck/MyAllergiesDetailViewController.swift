//
//  MyAllergiesDetailViewController.swift
//  AllerCheck
//
//  Created by Michael X Kelley on 4/23/19.
//  Copyright © 2019 Michael X Kelley. All rights reserved.
//

import UIKit
import Firebase

class MyAllergiesDetailViewController: UIViewController {

    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var allergyTextField: UITextField!
    @IBOutlet weak var deleteAllergyButton: UIButton!
    
    
    var allergy: Allergy!
    
    //MARK:- ViewDidLoad Setting Up ViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        if allergy == nil {
            allergy = Allergy()
            deleteAllergyButton.isHidden = true
        }
        allergyTextField.text = allergy.allergy
        
        if allergyTextField.text!.count > 0 {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
        
        allergyTextField.becomeFirstResponder()
        
        let tap = UITapGestureRecognizer(target: self.view, action:
            #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }
    
    //MARK:- Exiting the ViewController Function
    func leaveViewController() {
        if  (presentingViewController?.shouldPerformSegue(withIdentifier: "AddAllergy", sender: Any?.self) ?? false) {
            allergyTextField.resignFirstResponder()
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    //MARK:- Saving Data from ViewController to Allergy Class
    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
        self.allergy.allergy = self.allergyTextField.text!
        allergy.saveData { success in
            if success {
                print(self.allergy.allergy)
                self.leaveViewController()
            } else {
                print("Can't segue because of the error")
            }
        }
    }
    
    //MARK:- ViewController Changes Based on TextEditingChanged
    @IBAction func allergyFieldChanged(_ sender: UITextField) {
        if allergyTextField.text!.count > 0 {
            saveBarButton.isEnabled = true
            deleteAllergyButton.isHidden = false
        } else {
            saveBarButton.isEnabled = false
            deleteAllergyButton.isHidden = true
        }
    }
    
    //MARK:- Saving Data Using Return/Enter Key
    @IBAction func allergyFieldReturnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
        self.allergy.allergy = self.allergyTextField.text!
        allergy.saveData { success in
            if success {
                print(self.allergy.allergy)
                self.leaveViewController()
            } else {
                print("Can't segue because of the error")
            }
        }
    }
    
    //MARK:- Deleting Data from Firebase Storage Using Delete Button
    @IBAction func deleteAllergyButtonPressed(_ sender: UIButton) {
        let db = Firestore.firestore()
        db.collection("allergies").document(allergy.documentID).delete() { error in
            if let error = error {
                print("😡 ERROR: Deleting review documentID \(self.allergy.documentID) \(error.localizedDescription)")
            } else {
                let myAllergies = MyAllergies()
                myAllergies.loadData {
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
