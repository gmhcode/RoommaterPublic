//
//  Item.swift
//  Roommate Tracker
//
//  Created by Greg Hughes on 1/14/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import Foundation


class Item {
    
    var name: String
    var description: String?
    let uid: String
    
    var dictionary: [String : Any] {
        return
            [ "name" : name,
              "description" : description as Any,
              "uid" : uid ]
    }
    
    init(name:String, description: String, uid: String) {
        self.name = name
        self.description = description
        self.uid = uid
    }
    
    init?(withDict dict: [String : Any]) {
        guard let name = dict["name"] as? String,
            
            let uid = dict["uid"] as? String
            else { print(">>>\(#file) \(#line): guard let failed<<<"); return nil}
        
        if let description = dict["description"] as? String? {
            self.description = description            
        }
        self.name = name
        self.uid = uid
    }
}
