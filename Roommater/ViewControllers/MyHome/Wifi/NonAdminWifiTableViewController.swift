//
//  NonAdminWifiTableViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/23/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class NonAdminWifiTableViewController: UITableViewController {

    var place = PlaceController.shared.currentPlace
    
    @IBOutlet weak var networkNameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationView()
    }

    // MARK: - Table view data source
    func setUpNavigationView(){
        
        navigationItem.title = "Wifi"
        navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        networkNameLabel.text = place?.wifiNetworkName
        networkNameLabel.addGrayUnderline()
        passwordLabel.text = place?.wifiNetworkPassword
        passwordLabel.addGrayUnderline()
    }
    


}
