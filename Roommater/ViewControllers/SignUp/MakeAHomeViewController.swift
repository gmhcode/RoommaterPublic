//
//  MakeAHomeViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/22/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class MakeAHomeViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var homeNameTextField: UITextField!
    var currentUser = InternalUserController.shared.loggedInUser
    var place = PlaceController.shared.currentPlace
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatTextFields()
    }
    
    // MARK: - Actions
    
    @IBAction func createHomeButtonTapped(_ sender: Any) {
        
        guard let houseName = homeNameTextField.text
            else { return }
        
        guard let currentUser = currentUser else { return }
        
        PlaceController.shared.createPlace(adminUid: currentUser.uid, placeName: houseName, homeAddress: "") { (returnedPlace) in
            
            guard let returnedPlace = returnedPlace else {return}
            PlaceController.shared.currentPlace = returnedPlace
            
            guard let place = PlaceController.shared.currentPlace else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            
            PlaceController.shared.currentPlace?.admin = currentUser
            
            InternalUserController.shared.updateAdminStatus(forUser: currentUser, status: true, completion: { (user) in
                InternalUserController.shared.loggedInUser = user
            })
            
            InternalUserController.shared.updatePlaceUid(forUser: currentUser, toPlaceUid: returnedPlace.uid, completion: { (user) in
                guard let user = user else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
                
                InternalUserController.shared.loggedInUser = user
                PlaceController.shared.currentPlace = returnedPlace
                self.performSegue(withIdentifier: "addHomeSegue", sender: nil)
            })
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addHomeSegue" {
            
            guard let destinationVC = segue.destination as? AddHomeDetailsTableViewController else {return}
            
            destinationVC.place = PlaceController.shared.currentPlace
        }
    }
}

extension MakeAHomeViewController {
    
    func formatTextFields() {
        homeNameTextField.borderStyle = .none
        homeNameTextField.addUnderline()
    }
}
