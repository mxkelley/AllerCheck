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
    
    var allergy: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if allergy == nil {
            allergy = ""
        }
        allergyTextField.text = allergy
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindFromAllergySave" {
            allergy = allergyTextField.text
        }
    }
    
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        if  (presentingViewController?.shouldPerformSegue(withIdentifier: "AddAllergy", sender: Any?.self) ?? false) {
            allergyTextField.resignFirstResponder()
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    
    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
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
        allergy = allergyTextField.text
        performSegue(withIdentifier: "UnwindFromAllergySave", sender: Any?.self)
    }
    
    

}
