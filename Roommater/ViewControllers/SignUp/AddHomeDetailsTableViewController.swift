//
//  AddHomeDetailsTableViewController.swift
//  Roommate Tracker
//
//  Created by Greg Hughes on 1/16/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import UIKit

class AddHomeDetailsTableViewController: UITableViewController {
    
    @IBOutlet weak var addHouseRulesTextView: UITextView!
    @IBOutlet weak var addHouseRulesTableViewCell: UITableViewCell!
    
    @IBOutlet weak var addWifiTableCell: UITableViewCell!
    
    @IBOutlet weak var networkAndPassStack: UIStackView!
    
    @IBOutlet weak var sharedSpaceTableView: UITableView!
    
    @IBOutlet weak var addRentTextField: UITextField!
    
    @IBOutlet weak var wifiNetworkNameTextField: UITextField!
    
    @IBOutlet weak var wifiPasswordTextField: UITextField!
    
    var place = PlaceController.shared.currentPlace
//    let place = Place(placeName: "a", homeAddress: "a", adminUid: "a", uid: "a")
    
    var addHouseRulesIsToggled = true
    var addWifiInfoToggles = true
    var addSharedSpacesToggled = true
    var addRentTextFieldToggled = true
    var sharedSpacesButtonPressedTwice = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addHouseRulesTextView.isHidden = true
        addHouseRulesTextView.layer.borderWidth = 1
        addHouseRulesTextView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
        networkAndPassStack.isHidden = true
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
//        addRentTextField.isHidden = true
        place?.spaces = []
        wifiNetworkNameTextField.addUnderline()
        wifiPasswordTextField.addUnderline()


    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       print(indexPath.row)
        if indexPath.row == 1{
            if addHouseRulesIsToggled{
                
                return view.bounds.width * 0.25
            }
            else {return view.bounds.width * 0.60}
        }
        if indexPath.row == 2{
            if addWifiInfoToggles{
                
                return view.bounds.width * 0.25
            }
            else {return view.bounds.width * 0.60}
        }
        if indexPath.row == 3{
            
                
            return view.bounds.width * 0.25
           
            
        }
        
//        if indexPath.row == 4{
//            if addRentTextFieldToggled{
//
//                return view.bounds.width * 0.15
//            }
//            else {return view.bounds.width * 0.40}
//        }
        if indexPath.row == 4{
            return view.bounds.width * 0.30
            
        }
        
        return 190
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
        return 5
    }
    
    @IBAction func addHouseRulesbuttonTapped(_ sender: Any) {
        
        guard let place = place else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

        print("❇️ss")

       
        
        if addHouseRulesIsToggled {
            addHouseRulesIsToggled = false
            
            UIView.animate(withDuration: 0.5) {
                self.addHouseRulesTextView.isHidden = false
                self.tableView.layoutIfNeeded()
                
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
            
        }
        else {
            addHouseRulesIsToggled = true
            
            UIView.animate(withDuration: 0.5) {
                self.addHouseRulesTextView.isHidden = true
                self.tableView.layoutIfNeeded()
                
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
            
        }
        if addHouseRulesTextView.text != ""{
            PlaceController.shared.updateHomeRules(toPlace: place, homeRules: addHouseRulesTextView.text) { (place) in

                guard let place = place else { print("fuck"); return }

                self.place = place

            }

        }
    }
    
    
    
    
    
    
    @IBAction func wifiInformationButton(_ sender: Any) {
        
        guard let place = place else { return }
        guard let wifiNetworkNametext = wifiNetworkNameTextField.text,
            let wifiPassText = wifiPasswordTextField.text else { return }
        
        
        if wifiNetworkNameTextField.text != nil{
            
            PlaceController.shared.updateWifiInformation(toPlace: place, wifiName: wifiNetworkNametext, wifiPassword: wifiPassText) { (place) in
                
                self.place = place
            }
        }
        
        if addWifiInfoToggles {
            addWifiInfoToggles = false
            
            UIView.animate(withDuration: 0.5) {
                self.networkAndPassStack.isHidden = false
                
                self.tableView.layoutIfNeeded()
                
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
            
        }
        else {
            addWifiInfoToggles = true
            
            UIView.animate(withDuration: 0.5) {
                self.networkAndPassStack.isHidden = true
                
                self.tableView.layoutIfNeeded()
                
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
    }
//    
//    @IBAction func sharedSpacesButtonTapped(_ sender: Any) {
//        
//        if  sharedSpaceDataSource.place == nil {
//        sharedSpaceDataSource.place = self.place
//            sharedSpacesButtonPressedTwice = true
//            
//        }else {
//            self.place = sharedSpaceDataSource.place
//        }
//        
//        if addSharedSpacesToggled {
//            addSharedSpacesToggled = false
//            
//            UIView.animate(withDuration: 0.5) {
//                self.sharedSpaceTableView.isHidden = false
//                
//                self.tableView.layoutIfNeeded()
//                
//                self.tableView.beginUpdates()
//                self.tableView.endUpdates()
//            }
//            
//        }
//        else {
//            addSharedSpacesToggled = true
//            
//            UIView.animate(withDuration: 0.5) {
//                self.sharedSpaceTableView.isHidden = true
//                
//                self.tableView.layoutIfNeeded()
//                
//                self.tableView.beginUpdates()
//                self.tableView.endUpdates()
//            }
//        }
//        
//        PlaceController.shared.currentPlace = self.place
//    }
    
    @IBAction func addRentButtonTapped(_ sender: Any) {
        
        if addRentTextFieldToggled {
            addRentTextFieldToggled = false
            
            UIView.animate(withDuration: 0.5) {
                self.addRentTextField.isHidden = false
                
                self.tableView.layoutIfNeeded()
                
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
            
        }
        else {
            addRentTextFieldToggled = true
            
            UIView.animate(withDuration: 0.5) {
                self.addRentTextField.isHidden = true
                
                self.tableView.layoutIfNeeded()
                
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if sharedSpacesButtonPressedTwice != true{
            PlaceController.shared.currentPlace = self.place
        }
        PlaceController.shared.currentPlace = place
        
    }
    
    
}


extension AddHomeDetailsTableViewController : SharedSpaceTableViewCellDelegate {
   
    func addSpace(cell: SharedSpaceTableViewCell, space: String) {
        place?.spaces?.append(space)
        guard let indexPath = sharedSpaceTableView.indexPath(for: cell as UITableViewCell) else { return }
        let newIndexPath = IndexPath(item: indexPath.row + 1, section: indexPath.section)
        sharedSpaceTableView.insertRows(at: [newIndexPath], with: .automatic)
        
    }
}




