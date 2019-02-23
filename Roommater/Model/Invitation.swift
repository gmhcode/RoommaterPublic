//
//  Invitation.swift
//  Roommater
//
//  Created by Greg Hughes on 1/18/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import Foundation

class Invitation {
    
    var inviteCode: String
    var placeUid: String
    weak var place: Place?
    var active: Bool
    let uid: String
    
    var dictionary: [String: Any] {
        return
            [ "inviteCode" : inviteCode,
              "placeUid" : placeUid,
              "active" : active,
              "uid" : uid ]
    }
    
    init(toPlace place: Place, active: Bool = true, inviteCode: String = UUID().uuidString, uid: String) {
        
        self.placeUid = place.uid
        self.inviteCode = String(Array(inviteCode)[0...6])
        self.active = active
        self.uid = uid
    }
    
    init?(withDict dict: [String : Any]) {
        guard let inviteCode = dict[InvitationKey.inviteCode] as? String,
            let placeUid = dict[InvitationKey.placeUid] as? String,
            let active = dict[InvitationKey.active] as? Bool,
            let uid = dict[InvitationKey.uid] as? String
            else { print(">>>\(#file) \(#line): guard let failed<<<"); return nil}
        
        self.inviteCode = inviteCode
        self.placeUid = placeUid
        self.active = active
        self.uid = uid
    }
}


