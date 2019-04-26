//
//  MyFavoritesViewController.swift
//  AllerCheck
//
//  Created by Michael X Kelley on 4/24/19.
//  Copyright © 2019 Michael X Kelley. All rights reserved.
//

import UIKit

class MyFavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var favorites: Favorites!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        favorites = Favorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favorites.loadData {
            self.tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFavorite" {
            let destination = segue.destination as! MyFavoritesDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.favorite = favorites.favoritesArray[selectedIndexPath.row]
        }
    }

}

extension MyFavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.favoritesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = favorites.favoritesArray[indexPath.row].brandName
        cell.detailTextLabel?.text = favorites.favoritesArray[indexPath.row].productName
        return cell
    }
    
    
}
