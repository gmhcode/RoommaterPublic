//
//  SignUpViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/22/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var contentView: UIView!
    
    var user = InternalUserController.shared.loggedInUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTextFields()
    }
    
    // MARK: - Actions
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        guard let nameTextField = nameTextField.text,
            let  emailTextField = emailTextField.text,
            let phoneNumberTextField = phoneNumberTextField.text,
            let passwordTextField = passwordTextField.text else { return }
        
        InternalUserController.shared.createUser(fullname: nameTextField, emailAddress: emailTextField, password: passwordTextField, phoneNumber: phoneNumberTextField) { (user) in
            
            guard let user = user else {return}
            
            InternalUserController.shared.loggedInUser = user
            self.performSegue(withIdentifier: "signUp", sender: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension SignUpViewController{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "signUp"{
            
            guard let user = InternalUserController.shared.loggedInUser else { print("FUCKED UP");return}
            
            if let nav = segue.destination as? UINavigationController,
                let destistinationVC = nav.topViewController as? GetStartedViewController {
                destistinationVC.user = user
            }
        }
    }
    
    func formatTextFields() {
        nameTextField.borderStyle = .none
        emailTextField.borderStyle = .none
        phoneNumberTextField.borderStyle = .none
        passwordTextField.borderStyle = .none
        
        nameTextField.addUnderline()
        emailTextField.addUnderline()
        phoneNumberTextField.addUnderline()
        passwordTextField.addUnderline()
    }
}

