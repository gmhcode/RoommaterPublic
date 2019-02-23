//
//  AddRoommatesViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/24/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class AddRoommatesViewController: UIViewController {
    
    var place: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        place = PlaceController.shared.currentPlace
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func inviteButtonTapped(_ sender: Any) {
        guard let place = place else {print("❇️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        InvitationController.shared.createInvitation(place: place) { (success) in
            if success {
                DispatchQueue.main.async {
                    guard let invitationArray = place.invitationsUid else {print("❇️>>>\(#file) \(#line): guard let failed<<<"); return}
                    
                    let invitation = invitationArray[0]
                    
                    displayHouseCode(withInvitation: invitation)
                }
            }
        }
        
        
        func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
        }
        
        
        func displayHouseCode(withInvitation invitation: String) {
            
            
            let actionSheet = UIAlertController(title: "Your Home Code (expires after one use)", message:  "place.invitationsUid", preferredStyle: .actionSheet)
            
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: invitation, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 18.0)!])
            actionSheet.setValue(myMutableString, forKey: "attributedMessage")
            //changes font size and type
            
            
            let copyAction = UIAlertAction(title: "Copy + Invite", style: .destructive) { (_) in
                UIPasteboard.general.string = invitation
                displayShareSheet(invitation: invitation)
            }
        
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            actionSheet.addAction(cancelAction)
            actionSheet.addAction(copyAction)
            //  actionSheet.addAction(inviteAction)
            
            self.present(actionSheet, animated: true)
        }
        
        func displayShareSheet(invitation: String){
            
            let activityViewController = UIActivityViewController(activityItems: [invitation], applicationActivities: nil)
            
            self.present(activityViewController,animated: true, completion: nil)
        }
    }
    
    @IBAction func noRoomatesButtonTapped(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = true
    }
}

