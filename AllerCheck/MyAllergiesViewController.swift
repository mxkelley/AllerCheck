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
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var myAllergies: MyAllergies!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        myAllergies = MyAllergies()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myAllergies.loadData {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myAllergies.allergiesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade   )
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = myAllergies.allergiesArray[sourceIndexPath.row]
        myAllergies.allergiesArray.remove(at: sourceIndexPath.row)
        myAllergies.allergiesArray.insert(itemToMove, at: destinationIndexPath.row)
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
    
    @IBAction func unwindFromMyAllergiesDetailViewController (segue: UIStoryboardSegue) {
        let source = segue.source as! MyAllergiesDetailViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            myAllergies.allergiesArray[selectedIndexPath.row] = source.allergy
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: myAllergies.allergiesArray.count, section: 0)
            myAllergies.allergiesArray.append(source.allergy)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
    }
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
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
