//
//  Extensions.swift
//  Roommate Tracker
//
//  Created by Greg Hughes on 1/14/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import Foundation

extension Place: Equatable {
    static func == (lhs: Place, rhs: Place) -> Bool {
        
        return lhs.placeName == rhs.placeName && lhs.uid == rhs.uid
    }
}

extension InternalUser: Equatable {
    static func == (lhs: InternalUser, rhs: InternalUser) -> Bool {
        
        return lhs.fullname == rhs.fullname && lhs.uid == rhs.uid
    }
}

extension Item: Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        
        return lhs.name == rhs.name
    }
}

extension Event: Equatable{
    static func == (lhs: Event, rhs: Event) -> Bool {
        
        return lhs.creatorUid == rhs.creatorUid
            && lhs.date == rhs.date
            && lhs.name == rhs.name
    }
}
