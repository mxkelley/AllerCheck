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
//        controller.navigationItem.hidesBackButton = true
        clearDefaults()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showCamera()
    }
    
    func clearDefaults() {
//        let defaults = UserDefaults.standard
//        defaults.set("", forKey: "name")
//        defaults.set("", forKey: "calories")
//        defaults.set("", forKey: "carbohydrates")
//        defaults.set("", forKey: "fat")
//        defaults.set("", forKey: "protein")
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
        print("UPC Code from Barcode Scanner: \(code)")
        
        controller.reset()
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
