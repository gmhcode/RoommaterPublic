//
//  AdminRoommatesViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/22/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class AdminRoommatesViewController: UIViewController, UITableViewDelegate,UITableViewDataSource  {
    
    var place = PlaceController.shared.currentPlace
    
    var currentuser = InternalUserController.shared.loggedInUser
    
    @IBOutlet weak var roommateImage: UIImageView!
    
    @IBOutlet weak var secondTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpViews()
        
        secondTableView.delegate = self
        secondTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func setUpViews(){
        self.navigationItem.title = "Roommates"
        self.title = "Roommates"
        navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return place?.tenants?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SecondTableViewCell") as? SecondTableViewCell
        
        cell?.place = self.place
        cell?.user = place?.tenants?[indexPath.row]
        cell?.delegate = self
        
        return cell ?? UITableViewCell()
    }
    
    
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //
    //            // Delete the row from the data source
    //            tableView.deleteRows(at: [indexPath], with: .fade)
    //        } else if editingStyle == .insert {
    //            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    //        }
    //    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension AdminRoommatesViewController: AdminTableViewCellDelegate{
    func removeTenantButton(for cell: SecondTableViewCell) {
        removeTenantAlert(cell: cell)
    }
    
    
    
    
    
    
    func removeTenantAlert(cell: SecondTableViewCell){
        guard let place = place,
            let cellUser = cell.user else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        if cell.user?.admin == false && cell.user != InternalUserController.shared.loggedInUser{
            
            let alertController = UIAlertController(title: "REMOVE TENANT", message: "To confirm the removal of this tenant, please type their name exactly as it appears on this app", preferredStyle: .alert)
            
            var textField = UITextField()
            alertController.addTextField { (textfield) in
                textfield.placeholder = "type roommates full name EXACTLY as it appears in this app"
                textField = textfield

            }
            
            let removeTenantButton = UIAlertAction(title: "Remove Tenant", style: .destructive) { (_) in
                if textField.text == cellUser.fullname {
                    PlaceController.shared.updateRemoveTenantUid(toPlace: place, tenantUid: cellUser.uid, completion: { (place) in
                        self.place = place
                        self.secondTableView.reloadData()
                        
                    })
                }
                else {
                    self.wrongTenantNameAlert(cell: cell)
                }
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(removeTenantButton)
            alertController.addAction(cancelButton)
            
            present(alertController, animated: true)
        }
    }
    
    
    // this alert triggers if the name they entered doesnt match the name of the tenant they want to evict
    func wrongTenantNameAlert(cell: SecondTableViewCell){
        guard let place = place,
            let cellUser = cell.user else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        let alertController = UIAlertController(title: "Please Try Again", message: "The name you entered does not match the name in the person you selected. keep in mind this is case sensitive", preferredStyle: .alert)
        
        var textField = UITextField()
        alertController.addTextField { (textfield) in
            textfield.placeholder = "type roommates full name EXACTLY as it appears in this app"
            textField = textfield
        }
        
        let removeTenantButton = UIAlertAction(title: "REMOVE TENANT", style: .destructive) { (_) in
            
            if textField.text == cellUser.fullname {
                PlaceController.shared.updateRemoveTenantUid(toPlace: place, tenantUid: cellUser.uid, completion: { (place) in
                    self.place = place
                    self.secondTableView.reloadData()
                }
                )}
            else {
                self.wrongTenantNameAlert(cell: cell)
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelButton)
        alertController.addAction(removeTenantButton)
        
        present(alertController, animated: true)
    }
}
