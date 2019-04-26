//
//  MyAllergies.swift
//  AllerCheck
//
//  Created by Michael X Kelley on 4/23/19.
//  Copyright © 2019 Michael X Kelley. All rights reserved.
//

import Foundation
import Firebase

class MyAllergies {
    var searchableAllergies: [String] = []
    var doNotEat: Bool!
    
    var allergiesArray: [Allergy] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("allergies").addSnapshotListener{ (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: Adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.allergiesArray = []
            
            //there are querySnapshot.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents {
                let allergy = Allergy(dictionary: document.data())
                _ = Firestore.firestore()
                //Grab the userID
                guard let currentUser = (Auth.auth().currentUser?.uid) else {
                    print("*** ERROR: Could not save data because we don't have a valid postingUserID")
                    return
                }
                if allergy.postingUserID == currentUser {
                        allergy.documentID = document.documentID
                        self.allergiesArray.append(allergy)
                }
                
            }
            completed()
        }
    }
    
    func addSearchableAllergies(myListedAllergies: [String], completed: () -> ()) {
        searchableAllergies = []
        doNotEat = true
        for allergy in myListedAllergies {
            if allergy.lowercased() == "milk" {
                searchableAllergies.append(allergy)
                let milkAllergiesArray = ["butter","buttermilk","casein","caseinate","cheese","cream","curd","custard","diacetyl","ghee","half-and-half","lactalbumin","lactoferrin","lactose","lactulose","pudding","Recaldent","rennet","sour cream","sour milk","tagatose","whey","hydrolysate","yogurt"]
                for item in milkAllergiesArray {
                    searchableAllergies.append(item)
                }
            } else if allergy.lowercased() == "egg" || allergy.lowercased() == "eggs" {
                searchableAllergies.append("egg")
                let eggAllergiesArray = ["albumin","albumen","eggnog","globulin","livetin","lysozyme","mayonnaise","meringue","surimi","vitellin","ovo","ova","ovalbumin"]
                for item in eggAllergiesArray {
                    searchableAllergies.append(item)
                }
            } else if allergy.lowercased() == "wheat" {
                searchableAllergies.append("wheat")
                let wheatAllergiesArray = ["bread crumbs", "bulgur", "cereal extract", "club wheat", "couscous", "cracker meal", "durum", "einkorn", "emmer", "farina", "flour","hydrolyzed wheat protein", "Kamut","matzoh","matzo","matzah","matza","seitan","semolina","spelt","sprouted wheat","vital wheat gluten","wheat bran", "wheat germ", "wheat gluten", "wheat durum", "wheat grass", "wheat malt", "wheat sprouts", "wheat starch", "wheat protein", "whole wheat berries"]
                for item in wheatAllergiesArray {
                    searchableAllergies.append(item)
                }
            } else if allergy.lowercased() == "soy" {
                searchableAllergies.append("soy")
                let soyAllergiesArray = ["edamame", "miso", "natto", "soy", "soya", "soybean", "soy protein", "shoyu", "soy sauce", "tamari", "tempeh", "textured vegetable protein", "tvp", "tofu"]
                for item in soyAllergiesArray {
                    searchableAllergies.append(item)
                }
            } else if allergy.lowercased() == "shellfish" || allergy.lowercased() == "shell-fish" {
                searchableAllergies.append("shellfish")
                let shellfishAllergiesArray = ["barnacle","crab","crawfish","crawdad","crayfish","ecrevisse","krill","lobster","langouste","langoustine","moreton bay bugs", "scampi", "tomalley","prawns","shrimp","crevette","mollusk","abalone","clams","cherrystone","geoduck","littleneck","pismo","quahog","cockle","cuttlefish","limpet","lapas","opihi","mussels","octopus","oysters","periwinkle","scallops","sea cucumber","sea urchin","snails","escargot","squid","calamari","whelk","turban shell"]
                for item in shellfishAllergiesArray {
                    searchableAllergies.append(item)
                }
            } else if allergy.lowercased() == "tree nut" || allergy.lowercased() == "tree nuts" || allergy.lowercased() == "tree-nut" || allergy.lowercased() == "tree-nuts" || allergy.lowercased() == "treenut" || allergy.lowercased() == "treenuts" || allergy.lowercased() == "nuts" {
                searchableAllergies.append("tree nut")
                searchableAllergies.append("nut")
                let treenutAllergiesArray = ["almond","artificial nuts","beechnut","brazil nut","butternut","cashew","chestnut","chinquapin nut","filbert","hazelnut","gianduja","chocolatenut","ginkgo","hickory nut","litchi","lichee","lychee","macadamia","marzipan","almond paste","nangai nut","natural nut extract","nut butter","nut meal", "nut meat","nut paste","nut pieces","pecan","pesto","pili nut","pine nut", "indian nut","pignoli","pigñolia","pignon","piñon","pinyon","pistachio","praline","shea nut","walnut"]
                for item in treenutAllergiesArray {
                    searchableAllergies.append(item)
                }
            } else if allergy.lowercased() == "peanut" || allergy.lowercased() == "peanuts" {
                searchableAllergies.append("peanut")
                let peanutAllergiesArray = ["artificial nuts","beer nuts", "peanut oil", "goobers","ground nuts","mixed nuts","monkey nuts", "nut pieces","nut meat","peanut butter", "peanut flour", "peanut protein","hydrolysate"]
                for item in peanutAllergiesArray {
                    searchableAllergies.append(item)
                }
            } else if allergy.lowercased() == "fish" {
                searchableAllergies.append("fish")
                let fishAllergiesArray = ["barbecue sauce","bouillabaisse","caesar salad","caviar","deep fried","fish flavoring","fish flour","fish fume","fish gelatin","kosher gelatin","marine gelatin","fish oil", "fish sauce","imitation fish","shellfish isinglass","lutefisk maw","maw","fish stock","fishmeal","nouc mam","anchovy","roe","seafood flavoring","shark cartilage","shark fin","surimi","sushi","sashimi","worcestershire"]
                for item in fishAllergiesArray {
                    searchableAllergies.append(item)
                }
            } else {
                searchableAllergies.append(allergy)
            }
        }
        print("**** Searchable Allergies Added")
        print(searchableAllergies)
        completed()
    }
    
    func checkAllergies(ingredients: String, completed: () -> ()){
        print(ingredients)
        let defaultsData = UserDefaults.standard
        for allergy in searchableAllergies {
            if ingredients.lowercased().contains(allergy) == true {
                print("***INGREDIENT CONTAINS ALLERGEN")
                //TRUE = Product contains a given allergen (DO NOT EAT)
                doNotEat = true
                defaultsData.set(doNotEat, forKey: "doNotEat")
                completed()
                return
            }
        }
        print("^^^Ingredients does not contain allergen")
        doNotEat = false
        defaultsData.set(doNotEat, forKey: "doNotEat")
        completed()
    }
}
