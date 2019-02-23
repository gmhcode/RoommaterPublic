//
//  ShoppingList.swift
//  Roommate Tracker
//
//  Created by Greg Hughes on 1/14/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import Foundation

class ShoppingList {
    
    var itemsUid: [String]?
    var items: [Item]?
    let uid: String
    
    var dictionary: [String: Any] {
        return
            [ "itemsUid" : itemsUid as Any,
              "uid" : uid ]
    }
    
    init(itemsUid: [String]?, uid: String) {
        self.itemsUid = itemsUid
        self.uid = uid
    }
    
    init?(withDict dict: [String : Any]) {
        guard let itemsUid = dict["itemsUid"] as? [String]?,
            let uid = dict["uid"] as? String
            else { print(">>>\(#file) \(#line): guard let failed<<<"); return nil }
        
        self.itemsUid = itemsUid
        self.uid = uid
    }
}
