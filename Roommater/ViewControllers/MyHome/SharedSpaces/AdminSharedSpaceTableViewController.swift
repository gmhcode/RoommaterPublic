//
//  AdminSharedSpaceTableViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/23/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class AdminSharedSpaceTableViewController: UITableViewController {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "spaceCell", for: indexPath)
        
        
        cell.textLabel?.text = place?.spaces?[indexPath.row]
        // Configure the cell...
        
        return cell
    }
    
    
     // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let place = place,
            let space = place.spaces else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

        
        
     if editingStyle == .delete {
        
        PlaceController.shared.updateRemoveSpaces(toPlace: place, space: space[indexPath.row]) { (place) in
            PlaceController.shared.currentPlace = place
            tableView.reloadData()
        }
     // Delete the row from the data source
        
        
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
    
    func setUpNavigationBar(){
        self.navigationItem.title = "Shared Spaces"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSpaceButtonTapped)  )
    }
    


  
    @objc func addSpaceButtonTapped(){
        
        addSpaceAlert()
    }
    
    func addSpaceAlert(){
        guard let place = place else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        let alertController = UIAlertController(title: "Add Space", message: "Enter the name of the space you wish to add", preferredStyle: .alert)
        
        var textField = UITextField()
        alertController.addTextField { (theTextField) in
            textField = theTextField
        }
        
        
        let addButton = UIAlertAction(title: "ADD", style: .default) { (add) in
            guard let textField = textField.text else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            
            DispatchQueue.main.async {
                PlaceController.shared.updateAddSpaces(toPlace: place, space: textField, completion: { (place) in
                    
                    self.place = place
                    self.tableView.reloadData()
                })
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true)
    }
    
}
    
    

