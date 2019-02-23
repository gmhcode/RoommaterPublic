//
//  RoommatesTableViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/22/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class RoommatesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var nonAdminRoommatesTableView: UITableView!
    
    var place = PlaceController.shared.currentPlace
    
    var currentuser = InternalUserController.shared.loggedInUser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        nonAdminRoommatesTableView.delegate = self
        nonAdminRoommatesTableView.dataSource = self
        
        
        self.navigationItem.title = "Roommates"
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
    }
    
    
    
    
    
    func setUpViews(){
        
        
        
        self.navigationItem.title = "Roommates"
        self.title = "Roommates"
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        navigationItem.largeTitleDisplayMode = .always
        nonAdminRoommatesTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return place?.tenants?.count ?? 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "nonAdmincell") as? NonAdminTableViewCell
        
        cell?.place = self.place
        cell?.user = place?.tenants?[indexPath.row]
        
        
        return cell ?? UITableViewCell()
    }
    
    
  
    
}


    
    
    
    

