//
//  MyHomeTableViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/18/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class MyHomeTableViewController: UITableViewController {
    
    var place = PlaceController.shared.currentPlace
    var currentUser = InternalUserController.shared.loggedInUser
    
    
    @IBOutlet weak var homeAddressLabel: UILabel!
    @IBOutlet weak var homeRulesLabel: UILabel!
    @IBOutlet weak var wifiInformationLabel: UILabel!
    @IBOutlet weak var sharesSpacesLabel: UILabel!
    @IBOutlet weak var roomMatesLabel: UILabel!
    
    @IBOutlet weak var homeAddressCell: UITableViewCell!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        setupViews()
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.width * 0.15
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        homeAddressCell.selectedBackgroundView.backgroundColor
        if indexPath.row == 1 {
            if currentUser?.admin == true{
                let sb = UIStoryboard(name: "MyHome", bundle: nil)
                let adminVC = sb.instantiateViewController(withIdentifier: "AdminHomeRulesViewController") as! AdminHomeRulesViewController
                self.navigationController?.pushViewController(adminVC, animated: true)
                
            }
            else {
                let sb = UIStoryboard(name: "MyHome", bundle: nil)
                let nonAdminVC = sb.instantiateViewController(withIdentifier: "NonAdminHomeRulesViewController") as! NonAdminHomeRulesViewController
                self.navigationController?.pushViewController(nonAdminVC, animated: true)
            }
        }
        
        if indexPath.row == 2 {
            if currentUser?.admin == true{
                let sb = UIStoryboard(name: "MyHome", bundle: nil)
                let adminVC = sb.instantiateViewController(withIdentifier: "AdminWifiTableViewController") as! AdminWifiTableViewController
                self.navigationController?.pushViewController(adminVC, animated: true)
                
            }
            else {
                let sb = UIStoryboard(name: "MyHome", bundle: nil)
                let nonAdminVC = sb.instantiateViewController(withIdentifier: "NonAdminWifiTableViewController") as! NonAdminWifiTableViewController
                self.navigationController?.pushViewController(nonAdminVC, animated: true)
            }
        }
        
        
        if indexPath.row == 3 {
            if currentUser?.admin == true{
                let sb = UIStoryboard(name: "MyHome", bundle: nil)
                let adminVC = sb.instantiateViewController(withIdentifier: "AdminSharedSpaceTableViewController") as! AdminSharedSpaceTableViewController
                self.navigationController?.pushViewController(adminVC, animated: true)
                
            }
            else {
                let sb = UIStoryboard(name: "MyHome", bundle: nil)
                let nonAdminVC = sb.instantiateViewController(withIdentifier: "NonAdminSharedSpaceTableViewController") as! NonAdminSharedSpaceTableViewController
                self.navigationController?.pushViewController(nonAdminVC, animated: true)
            }
        }
        
        
        if indexPath.row == 4 {
            
            if currentUser?.admin == true{
                let sb = UIStoryboard(name: "MyHome", bundle: nil)
                let adminVC = sb.instantiateViewController(withIdentifier: "AdminRoommatesViewController") as! AdminRoommatesViewController
                self.navigationController?.pushViewController(adminVC, animated: true)
            }
            else {
                
                let sb = UIStoryboard(name: "MyHome", bundle: nil)
                let nonAdminVC = sb.instantiateViewController(withIdentifier: "RoommatesViewController") as! RoommatesViewController
                
                self.navigationController?.pushViewController(nonAdminVC, animated: true)
            }
        }
    }
    
    
    
    @IBAction func inviteButtonTapped(_ sender: Any) {
        
        
        
        func displayHouseCode(){
            
            guard let place = place else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<< "); return}
            
            
            InvitationController.shared.createInvitation(place: place) { (success) in
                if success{
                    
                    guard let inviteCode = place.invitationsUid?.last else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

                    let actionSheet = UIAlertController(title: "Your Home Code", message: "inviteCode", preferredStyle: .actionSheet)
                    
                    var myMutableString = NSMutableAttributedString()
                    myMutableString = NSMutableAttributedString(string: inviteCode, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 18.0)!])
                    actionSheet.setValue(myMutableString, forKey: "attributedMessage")
                    //changes font size and type
                    
                    
                    let copyAction = UIAlertAction(title: "Copy", style: .destructive) { (_) in
                        UIPasteboard.general.string = inviteCode
                        displayShareSheet()
                    }
                   
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    
                    
                    actionSheet.addAction(copyAction)
                    actionSheet.addAction(cancelAction)
                    
                    self.present(actionSheet, animated: true)
                }
                
                func displayShareSheet(){
                    
                     guard let inviteCode = place.invitationsUid?.last else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
                    
                    let activityViewController = UIActivityViewController(activityItems: [inviteCode as NSString], applicationActivities: nil)
                    
                    self.present(activityViewController,animated: true, completion: nil)
                }
            }
        }
        displayHouseCode()
    }
    
    
    func setupViews(){
        homeAddressLabel.addGrayUnderline()
        homeRulesLabel.addGrayUnderline()
        wifiInformationLabel.addGrayUnderline()
        sharesSpacesLabel.addGrayUnderline()
        roomMatesLabel.addGrayUnderline()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
}
