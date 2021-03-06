//
//  FirebaseController.swift
//  Roommater
//
//  Created by Drew on 1/14/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseLoginController {
    
    private static let firebaseAuth = Auth.auth()
    
    static func signUpNewUser(withEmail email: String, password: String, completion: @escaping (User?) -> Void) {
        
        firebaseAuth.createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print(">>>>>>> ❌ There was an error in \(#file): \(#function): \(#line) \(error) \(error.localizedDescription) <<<<<<<")
                completion(nil)
                return
            }
            
            guard let user = authResult?.user
                else { printGuardError(); completion(nil); return }
            completion(user)
        }
    }
    
    static func signInUser(withEmail email: String, password: String, completion: @escaping (User?) -> Void) {
        
        firebaseAuth.signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
<<<<<<< HEAD
                print(">>>>>>> ❌There was an error in \(#file): \(#function): \(#line) \(error) \(error.localizedDescription) <<<<<<<")
=======
                print(">>> There was an error in \(#file): \(#line) \(error) \(error.localizedDescription) <<<")
>>>>>>> 7bcd23d8d90245bd34fd505512b973d607c7385e
                completion(nil)
                return
            }
            
            guard let user = authResult?.user
                else { print(">>>\(#file) \(#line): guard let failed<<<"); completion(nil); return }
            
            completion(user)
            
//            guard let <#item#> = <#item#> else { print(">>>\(#file) \(#line): guard let failed<<<"); return }
        }
    }
    
    static func signOutUser() {
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    static func updatePassword(withEmail email: String, completion: @escaping (Bool) -> ()) {
        
        firebaseAuth.sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                print(">>>>>>> There was an error in \(#file): \(#function): \(#line) \(error) \(error.localizedDescription) <<<<<<<")
                completion(false)
                return
            }
            completion(true)
            print("Password reset request sent")
        }
    }
    
    static func verifyPassword(withEmail email: String, completion: @escaping (Bool) -> ()) {
        
    }
}
