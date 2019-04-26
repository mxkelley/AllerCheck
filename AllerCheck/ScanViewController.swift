//
//  ScanViewController.swift
//  AllerCheck
//
//  Created by Michael X Kelley on 4/23/19.
//  Copyright © 2019 Michael X Kelley. All rights reserved.
//

//NOTE: This page is modeled after an app created by former student Vlad Chilom

import UIKit
import AVFoundation
import BarcodeScanner

class ScanViewController: UIViewController {

    let controller = BarcodeScannerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.codeDelegate = self
        controller.errorDelegate = self
        controller.dismissalDelegate = self
        
        clearUserDefaults()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showCamera()
    }
    
    func clearUserDefaults() {
        let defaultsData = UserDefaults.standard
        let food = FoodUPCs()
        food.foodUPCArray = []
        defaultsData.set(0, forKey: "upc")
        defaultsData.set("", forKey: "brand")
        defaultsData.set("", forKey: "name")
        defaultsData.set("", forKey: "description")
        defaultsData.set("", forKey: "ingredients")
    }
    
    func showCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            controller.title = "Barcode Scanner"
            navigationController?.pushViewController(controller, animated: true)
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                if response {
                    self.controller.title = "Barcode Scanner"
                    self.navigationController?.pushViewController(self.controller, animated: true)
                } else {
                    self.showAlert(title: "Camera Unavailable", message: "AllerCheck is unable to access the camera on this device.")
                }
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        view.addSubview(alertController.view)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension ScanViewController: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        let defaultsData = UserDefaults.standard
        let food = FoodUPCs()
        let myAllergies = MyAllergies()
        var allergiesArray: [String] = []
        
        myAllergies.loadData {
            for index in 0..<myAllergies.allergiesArray.count {
                allergiesArray.append(myAllergies.allergiesArray[index].allergy)
            }
        }
        
        print("UPC Code from Barcode Scanner: \(code)")
        
        food.getFoodData(UPC: Int(code)!, completed: {
            defaultsData.set(food.foodUPCArray[0].upc, forKey: "upc")
            defaultsData.set(food.foodUPCArray[0].brand, forKey: "brand")
            defaultsData.set(food.foodUPCArray[0].name, forKey: "name")
            defaultsData.set(food.foodUPCArray[0].description, forKey: "description")
            defaultsData.set(food.foodUPCArray[0].ingredients, forKey: "ingredients")
            print("Completed")
            
            myAllergies.addSearchableAllergies(myListedAllergies: allergiesArray) {
                
                myAllergies.checkAllergies(ingredients: defaultsData.string(forKey: "ingredients")!) {
                    let delayTime = DispatchTime.now() + 2
                    DispatchQueue.main.asyncAfter(deadline: delayTime ) {
                        self.controller.reset()
                        self.tabBarController?.selectedIndex = 2
                    }
                }
                
            }
            
        })
        
    }
    
}

extension ScanViewController: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
    
}

extension ScanViewController: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
