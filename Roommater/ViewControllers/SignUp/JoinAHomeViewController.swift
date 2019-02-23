//
//  JoinAHomeViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/22/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class JoinAHomeViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var joinAHomeTextField: UITextField!
    var currentUser = InternalUserController.shared.loggedInUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTextFields()
    }
    
    // MARK: - Actions
    
    @IBAction func joinButtonTapped(_ sender: Any) {
        
        guard let joinHomeText = joinAHomeTextField.text, let currentUser = currentUser else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        InvitationController.shared.fetchInvitationToPlace(withCode: joinHomeText) { (placeUID) in
            
            guard let placeUID = placeUID else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<< INVITATION CODE WAS INCORRECT"); return}
            
            PlaceController.shared.fetchPlace(withUid: placeUID, completion: { (place) in
                guard let place = place else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
                
                PlaceController.shared.updateAddTenantUid(toPlace: place, tenantUid: currentUser.uid, completion: { (place) in
                    guard let place = place else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
                    PlaceController.shared.currentPlace = place
                    
                    InternalUserController.shared.updatePlaceUid(forUser: currentUser, toPlaceUid: place.uid, completion: { (user) in
                        guard let user = user else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
                        
                        self.currentUser = user
                        self.performSegue(withIdentifier: "joinHome", sender: nil)
                        self.navigationController?.navigationBar.isHidden = true
                    })
                })
            })
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension JoinAHomeViewController {
    
    func formatTextFields() {
        joinAHomeTextField.borderStyle = .none
        joinAHomeTextField.addUnderline()
    }
}
