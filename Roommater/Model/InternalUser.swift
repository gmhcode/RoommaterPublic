//
//  User.swift
//  Roommate Tracker
//
//  Created by Greg Hughes on 1/14/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import UIKit

class InternalUser  {
    
    var fullname: String
    var emailAddress: String
    var phoneNumber: String?
    var profileImageUrl: String?
    var profileImage: UIImage?
    var placeUid: String?
    var eventsUid: [String]?
    var events: [Event]?
    var admin: Bool
    weak var place: Place?
    let uid: String
    
    var dictionary: [String : Any] {
        return
            [ UserKey.fullname: fullname,
              UserKey.emailAddress: emailAddress,
              UserKey.phoneNumber: phoneNumber as Any,
              UserKey.profileImageUrl: profileImageUrl as Any,
              UserKey.placeUid: placeUid as Any,
              UserKey.eventsUid: eventsUid as Any,
              UserKey.admin: admin,
              UserKey.uid: uid ]
    }
    
    init(fullname: String, emailAddress: String, phoneNumber: String, profile admin: Bool = false, uid: String) {
        
        self.fullname = fullname
        self.emailAddress = emailAddress
        self.admin = admin
        self.uid = uid
    }
    
    // MARK: - Failable initializer for Firebase
    init?(withDict dict: [String: Any]) {
        
        guard let fullname = dict[UserKey.fullname] as? String,
            let emailAddress = dict[UserKey.emailAddress] as? String,
            let admin = dict[UserKey.admin] as? Bool,
            let uid = dict[UserKey.uid] as? String
            else { print(">>>\(#file) \(#line): guard let failed<<<"); return nil}
        
        
        if let phoneNumber = dict[UserKey.phoneNumber] as? String? {
            self.phoneNumber = phoneNumber
        }

        if let profileImageUrl = dict[UserKey.profileImageUrl] as? String? {
            self.profileImageUrl = profileImageUrl
        }
        
        if let placeUid = dict[UserKey.placeUid] as? String? {
            self.placeUid = placeUid
        }
        
        if let eventsUid = dict[UserKey.eventsUid] as? [String]? {
            self.eventsUid = eventsUid
        }
        
        self.fullname = fullname
        self.emailAddress = emailAddress
        self.admin = admin
        self.uid = uid
    }
}
