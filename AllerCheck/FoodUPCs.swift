//
//  FoodUPCs.swift
//  AllerCheck
//
//  Created by Michael X Kelley on 4/23/19.
//  Copyright © 2019 Michael X Kelley. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FoodUPCs {
    var foodUPCArray: [FoodUPCInfo] = []
    var apiURLStart = "https://api.nutritionix.com/v1_1/item?"
    var apiUPCStart = "upc="
    var apiUPC: Int = 0
    var apiAppIDStart = "&appId="
    var apiAppID = "355ed329"
    var apiAppKeyStart = "&appKey="
    var apiAppKey = "ad485a869f0ac5af90d7f4705b2d89de"
    
    
    //MARK:- API Call Function
    func getFoodData(UPC: Int, completed: @escaping () -> ()) {
        apiUPC = UPC
        Alamofire.request("\(apiURLStart)\(apiUPCStart)\(apiUPC)\(apiAppIDStart)\(apiAppID)\(apiAppKeyStart)\(apiAppKey)").responseJSON { response
            in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let upc = self.apiUPC
                let brand = json["brand_name"].stringValue
                let name = json["item_name"].stringValue
                let description = json["item_description"].stringValue
                let ingredients = json["nf_ingredient_statement"].stringValue
                self.foodUPCArray.append(FoodUPCInfo(upc: upc, brand: brand, name: name, description: description, ingredients: ingredients))
                print("\(upc)||\(brand)||\(name)||\(ingredients)")
            case .failure(let error):
                print("ERROR: \(error.localizedDescription) failed to get data from url \(self.apiURLStart)\(self.apiUPCStart)\(self.apiUPC)\(self.apiAppIDStart)\(self.apiAppID)\(self.apiAppKeyStart)\(self.apiAppKey)")
            }
            completed()
        }
    }

}
