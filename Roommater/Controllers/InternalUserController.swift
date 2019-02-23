//
//  UserController.swift
//  Roommate Tracker
//
//  Created by Greg Hughes on 1/14/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import Foundation
import Firebase

class InternalUserController {
    
    static let shared = InternalUserController(); private init() {}
    
    var loggedInUser : InternalUser?
    
    /**
     Creates user credentials for logged in user
     */
    func createUser(fullname: String, emailAddress: String, password: String, phoneNumber: String, completion: @escaping (InternalUser?)->()){
        FirebaseLoginController.signUpNewUser(withEmail: emailAddress, password: password) { (authorizedUser) in
            guard let authorizedUser = authorizedUser else { print(">>>\(#file) \(#line): guard let failed<<<"); completion(nil); return }
            
            let newUser = InternalUser(fullname: fullname, emailAddress: emailAddress, phoneNumber: phoneNumber, uid: authorizedUser.uid)
            let dbref = FirebaseController.db.collection("users").document(authorizedUser.uid)
            
            FirebaseController.save(objectDict: newUser.dictionary, to: dbref, completion: { (success) in
                if success {
                    self.loggedInUser = newUser
                    completion(newUser)
                }
            })
        }
    }
    
    func loginUser(withEmail email: String, password: String, completion: @escaping (InternalUser?) -> Void) {
        FirebaseLoginController.signInUser(withEmail: email, password: password) { (user) in
            if let user = user {
                InternalUserController.shared.fetchUser(withUid: user.uid, completion: { (iuser) in
                    if let iuser = iuser {
                        completion(iuser)
                    }
                })
            }
        }
    }
    
    /// Call on firebase manager to log out.
    /// sets self.loggedInUser = nil (logging out logged in user)
    func logOut() {
        
        FirebaseLoginController.signOutUser()
        self.loggedInUser = nil
    }
    
    private func updateUser(_ user: InternalUser, completion: @escaping (InternalUser?) -> Void) {
        
//        user.admin = false
        let dbref = FirebaseController.db.collection("users").document(user.uid)
        FirebaseController.save(objectDict: user.dictionary, to: dbref) { (success) in
            if success {
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
    
    /// User sign in to the app
    func signIn(emailAddress: String, password: String, completion: @escaping (Bool) -> Void) {
        
        FirebaseLoginController.signInUser(withEmail: emailAddress, password: password) { (authorizedUser) in
            guard let authorizedUser = authorizedUser else { print(">>>\(#file) \(#line): guard let failed<<<"); completion(false); return }
            let dbref = FirebaseController.db.collection("users").document(authorizedUser.uid)
            
            FirebaseController.fetch(fromRef: dbref, completion: { (snapshot) in
                guard let snapshotData = snapshot?.data() else { print(">>>\(#file) \(#line): guard let failed<<<"); completion(false); return }
                self.loggedInUser = InternalUser(withDict: snapshotData)
                completion(true)
            })
        }
    }
    
    func fetchUser(withUid uid: String, completion: @escaping (InternalUser?) -> Void) {
        let query = FirebaseController.db.collection("users").whereField("uid", isEqualTo: uid)
        FirebaseController.fetch(withQuery: query) { (snapshots) in
            if !snapshots.isEmpty {
                let user = InternalUser(withDict: snapshots[0].data())
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
    
    func leavePlace(forTenant tenant: InternalUser, completion: @escaping (InternalUser?) -> Void) {
        
        tenant.placeUid = nil
        let tenantDbREf = FirebaseController.db.collection("users").document(tenant.uid)
        FirebaseController.save(objectDict: tenant.dictionary, to: tenantDbREf) { (success) in
            if success {
                completion(tenant)
            } else {
                completion(nil)
            }
        }
    }
    
    func uploadImage(forUser: InternalUser, completion: @escaping (Bool) -> ()) {
        
    }
    
    
    func updatePlaceUid(forUser user: InternalUser, toPlaceUid uid: String, completion: @escaping (InternalUser?) -> Void) {
        user.placeUid = uid
        updateUser(user, completion: completion)
    }
    
    func updateAdminStatus(forUser user: InternalUser, status: Bool, completion: @escaping (InternalUser?) -> Void) {
        user.admin = status
//        updateUser(user, completion: completion)
    }
    
    func updateUserImageUrl(forUser user: InternalUser, imageUrlString url: String, completion: @escaping(InternalUser?) -> Void) {
        user.profileImageUrl = url
        updateUser(user, completion: completion)
    }
    
    func updateUserCredentials(forUser user: InternalUser, fullname: String, email: String, toNumber number: String, completion: @escaping (InternalUser?) -> Void) {
        user.fullname = fullname
        user.emailAddress = email
        // TODO : email change request through AUTH
        user.phoneNumber = number
        
        updateUser(user, completion: completion)
    }
    
    func updateDeleteUser(withUid userUid: String, completion: @escaping (Bool) -> Void) {
        
        let dbref = FirebaseController.db.collection("users").document(userUid)
        
        FirebaseController.delete(fromRef: dbref) { (success) in
            if success {
                FirebaseLoginController.deleteAuthAccount(withUid: userUid, completion: { (success) in
                    if success {
                        FirebaseLoginController.signOutUser()
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
            } else {
                completion(false)
            }
        }
    }
}
