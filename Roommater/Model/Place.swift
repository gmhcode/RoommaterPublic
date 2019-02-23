//
//  Place.swift
//  Roommate Tracker
//
//  Created by Greg Hughes on 1/14/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import Foundation
import UIKit

class Place {
    
    var placeName: String
    var homeAddress: String?
    var adminUid: [String]
    weak var admin: InternalUser?
    var tenantsUid: [String]?
    var tenants: [InternalUser]?
    var eventsUid: [String]?
    var events: [Event]?
    var shoppingListUid: String?
    weak var shoppingList: ShoppingList?
    var scheduledEventsUid: [String]?
    var scheduledEvents: [Event]?
    var spaces: [String]?
    var invitationsUid: [String]?
    var homeRules: String?
    var wifiNetworkName: String?
    var wifiNetworkPassword: String?
    let uid: String
    
    var dictionary: [String : Any] {
        return
            [ PlaceKey.placeName: placeName,
              PlaceKey.homeAddress: homeAddress as Any,
              PlaceKey.adminUid: adminUid,
              PlaceKey.tenantsUid: tenantsUid as Any,
              PlaceKey.shoppingListUid: shoppingListUid as Any,
              PlaceKey.scheduledEventsUid: scheduledEventsUid as Any,
              PlaceKey.spaces: spaces as Any,
              PlaceKey.invitationsUid: invitationsUid as Any,
              PlaceKey.homeRules: homeRules as Any,
              PlaceKey.wifiNetworkName: wifiNetworkName as Any,
              PlaceKey.wifiNetworkPassword: wifiNetworkPassword as Any,
              PlaceKey.uid: uid ]
    }
    
    init(placeName: String, homeAddress: String?, adminUid: [String], uid: String) {
        self.placeName = placeName
        self.homeAddress = homeAddress
        self.adminUid = adminUid
        self.uid = uid
    }
    
    init?(withDict dict: [String: Any]) {
        guard let placeName = dict[PlaceKey.placeName] as? String,
            let adminUid = dict[PlaceKey.adminUid] as? [String],
            let uid = dict[PlaceKey.uid] as? String
            else { print(">>>\(#file) \(#line): guard let failed<<<"); return nil}
        
        if let homeAddress = dict[PlaceKey.homeAddress] as? String? {
            self.homeAddress = homeAddress
        }
        
        if let tenantsUid = dict[PlaceKey.tenantsUid] as? [String]? {
            self.tenantsUid = tenantsUid
        }
        
        if let shoppingListUid = dict[PlaceKey.shoppingListUid] as? String? {
            self.shoppingListUid = shoppingListUid
        }
        
        if let scheduledEventsUid = dict[PlaceKey.scheduledEventsUid] as? [String]? {
            self.scheduledEventsUid = scheduledEventsUid
        }
        
        if let spaces = dict[PlaceKey.spaces] as? [String]? {
            self.spaces = spaces
        }
        
        if let invitationsUid = dict[PlaceKey.invitationsUid] as? [String]? {
            self.invitationsUid = invitationsUid
        }
        
        if let homeRules = dict[PlaceKey.homeRules] as? String? {
            self.homeRules = homeRules
        }
        
        if let wifiNetworkName = dict[PlaceKey.wifiNetworkName] as? String? {
            self.wifiNetworkName = wifiNetworkName
        }
        
        if let wifiNetworkPassword = dict[PlaceKey.wifiNetworkPassword] as? String? {
            self.wifiNetworkPassword = wifiNetworkPassword
        }
        
        self.placeName = placeName
        self.adminUid = adminUid
        self.uid = uid
    }
}
