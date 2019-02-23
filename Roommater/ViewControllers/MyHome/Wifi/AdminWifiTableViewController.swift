//
//  AdminWifiTableViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/23/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class AdminWifiTableViewController: UITableViewController {

    @IBOutlet weak var underlineView1: UIView!
    @IBOutlet weak var underlineView2: UIView!
    
    @IBOutlet weak var networkNameTextField: UITextField!
    
    @IBOutlet weak var networkPasswordTextField: UITextField!
    
    var place = PlaceController.shared.currentPlace
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        
    }
    
    func setUpViews(){
        
    self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        self.navigationItem.title = "Wifi"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        
        networkNameTextField.text = place?.wifiNetworkName
        networkPasswordTextField.text = place?.wifiNetworkPassword
        
        underlineView1.addGrayUnderline()
        underlineView2.addGrayUnderline()
        
    }


    @objc func editButtonTapped(){
        
        addWifiAlert()
        
    }
    
    func addWifiAlert(){
        guard let place = place else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

        
        
        let alertController = UIAlertController(title: "Edit Wifi Info", message: nil, preferredStyle: .alert)
        
        var wifiTextField1 = UITextField()
        var wifiTextField2 = UITextField()
        alertController.addTextField { (text) in
            text.placeholder = "Edit network name here"
            wifiTextField1 = text
        }
        alertController.addTextField { (text) in
            text.placeholder = "Edit password here"
            wifiTextField2 = text
        }
        
        let okButton = UIAlertAction(title: "OK", style: .default) { (action) in
            PlaceController.shared.updateWifiInformation(toPlace: place, wifiName: wifiTextField1.text, wifiPassword: wifiTextField2.text, completion: { (place) in
                self.place = place
                self.tableView.reloadData()
            })
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)

        present(alertController, animated: true)
    }
}
