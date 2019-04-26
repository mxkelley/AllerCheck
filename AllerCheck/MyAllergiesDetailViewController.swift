//
//  MyAllergiesDetailViewController.swift
//  AllerCheck
//
//  Created by Michael X Kelley on 4/23/19.
//  Copyright © 2019 Michael X Kelley. All rights reserved.
//

import UIKit

class MyAllergiesDetailViewController: UIViewController {

    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var allergyTextField: UITextField!
    
    var allergy: Allergy!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if allergy == nil {
            allergy = Allergy()
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
    
    
    
    @IBAction func allergyFieldChanged(_ sender: UITextField) {
        if allergyTextField.text!.count > 0 {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }
    
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
    
    

}
