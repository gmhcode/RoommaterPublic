//
//  EditProfileInfoViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/23/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class EditProfileInfoViewController: UIViewController {
    
    var currentUser = InternalUserController.shared.loggedInUser
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = currentUser {
            nameTextField.text = currentUser.fullname
            emailTextField.text = currentUser.emailAddress
            phoneNumberTextField.text = currentUser.phoneNumber ?? ""
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        // TODO: Implement alert for guard let fail
        guard let currentUser = currentUser else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
        
        if let nameText = nameTextField.text {
            currentUser.fullname = nameText
        }
        
        if let emailText = emailTextField.text {
            currentUser.emailAddress = emailText
        }
        
        if let phoneNumberText = phoneNumberTextField.text {
            currentUser.phoneNumber = phoneNumberText
        }
        
        InternalUserController.shared.updateUserCredentials(forUser: currentUser, fullname: currentUser.fullname, email: currentUser.emailAddress, toNumber: currentUser.phoneNumber ?? "") { (user) in
            guard let user = user else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
            
            InternalUserController.shared.loggedInUser = user
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
