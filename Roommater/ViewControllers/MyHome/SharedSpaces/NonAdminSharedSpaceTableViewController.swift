//
//  NonAdminSharedSpaceTableViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/23/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class NonAdminSharedSpaceTableViewController: UITableViewController {

    var place = PlaceController.shared.currentPlace
    @IBOutlet weak var addSpaceButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        
        
        
    }
    
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return PlaceController.shared.currentPlace?.spaces?.count ?? 1
    }
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "spaceCell2", for: indexPath)
        
        
        cell.textLabel?.text = place?.spaces?[indexPath.row]
        // Configure the cell...
        
        return cell
    }
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    func setUpNavigationBar(){
        self.navigationItem.title = "Shared Spaces"
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationItem.largeTitleDisplayMode = .always
}

}
