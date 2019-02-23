//
//  SignInViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/22/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var currentUser = InternalUserController.shared.loggedInUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTextFields()
    }
    
    // MARK: - Actions
    
    @IBAction func signInButtonTapped(_ sender: Any) {

        guard let email = emailTextField.text,
            let password = passwordTextField.text else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
        
//        InternalUserController.shared.loginUser(withEmail: email, password: password)
        InternalUserController.shared.loginUser(withEmail: "1@1.com", password: "1234567")
        { (user) in
            guard let user = user else {print(">>>\(#file) \(#line): guard let failed<<<"); return}
            
            InternalUserController.shared.loggedInUser = user
            
            if let currentUser = InternalUserController.shared.loggedInUser,
                let userPlaceUid = currentUser.placeUid {
                
                PlaceController.shared.fetchPlace(withUid: userPlaceUid, completion: { (place) in
                    
                    guard let place = place else {print(">>>\(#file) \(#line): guard let failed<<<"); return}
                    
                    PlaceController.shared.currentPlace = place
                    
                    guard let userUid = InternalUserController.shared.loggedInUser?.uid else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
                    
                    
                    // TODO: Add workflow for user with no place
                    if place.tenantsUid?.contains(userUid) ?? false {
                        
                        if place.adminUid.contains(userUid) {
                            InternalUserController.shared.loggedInUser?.admin = true
                        }
                        var tenants: [InternalUser] = []
                        
                        guard let currentPlace = PlaceController.shared.currentPlace,
                            let tenantsUid = currentPlace.tenantsUid
                            else {print(">>>\(#file) \(#line): guard let failed<<<"); return}
                        
                        let dispatchGroup = DispatchGroup()
                        
                        dispatchGroup.enter()
                        
                        for tenantUid in tenantsUid {
                            
                            InternalUserController.shared.fetchUser(withUid: tenantUid, completion: { (user) in
                                guard let user = user else {print("♊️>>>\(#file) \(#line): guard let failed<<<"); return}
                                FirebaseStorageController.fetchImage(forUser: user, completion: { (image) in
                                    user.profileImage = image
                                })
                                tenants.append(user)
                                print(tenants)
                                
                                PlaceController.shared.currentPlace?.tenants = tenants
                            })
                        }
                        dispatchGroup.leave()
                        print(tenants)

                        dispatchGroup.notify(queue: .main, execute: {
                            PlaceController.shared.currentPlace?.tenants = tenants
                            self.performSegue(withIdentifier: "signIn", sender: nil)
                        })
                    }
               })
            }
        }
    }
    
    //TODO: delete this when we have a way for someone who does not have a place to access their profile
    @IBAction func joinOrCreateHome(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
        
        InternalUserController.shared.loginUser(withEmail: email, password: password) { (user) in
            
            guard let user = user else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            
            
            let sb = UIStoryboard(name: "SignUp", bundle: nil)
            let getStartedVC = sb.instantiateViewController(withIdentifier: "GetStartedViewController") as! GetStartedViewController
            
            self.present(getStartedVC, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension SignInViewController {
    
    func formatTextFields() {
        emailTextField.borderStyle = .none
        passwordTextField.borderStyle = .none
        
        emailTextField.addUnderline()
        passwordTextField.addUnderline()
    }
}


