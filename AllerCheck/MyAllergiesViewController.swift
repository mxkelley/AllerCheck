//
//  MyAllergiesViewController.swift
//  AllerCheck
//
//  Created by Michael X Kelley on 4/23/19.
//  Copyright © 2019 Michael X Kelley. All rights reserved.
//

import UIKit

class MyAllergiesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var myAllergies: MyAllergies!
    var allergy: Allergy!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        myAllergies = MyAllergies()
        allergy = Allergy()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myAllergies.loadData {
            self.tableView.reloadData()
        }
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAllergy" {
            let destination = segue.destination as! MyAllergiesDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.allergy = myAllergies.allergiesArray[selectedIndexPath.row]
        } else if segue.identifier == "AddAllergy" {
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: true)
            }
        }
    }

}

extension MyAllergiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAllergies.allergiesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = myAllergies.allergiesArray[indexPath.row].allergy
        return cell
    }
    
    
}
