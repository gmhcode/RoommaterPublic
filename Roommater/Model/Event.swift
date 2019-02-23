//
//  Event.swift
//  Roommate Tracker
//
//  Created by Greg Hughes on 1/14/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import Foundation

class Event {
    
    var name: String
    var description: String?
    let creatorUid: String
    weak var creator: InternalUser?
    var participantsUid: [String]?
    var participants: [InternalUser]?
    var type: EventType
    var status: EventStatus
    var space: String?
    var date: TimeInterval
    var startTime: Date?
    var endTime: Date?
    var isRecurring: Bool
    var recurringInterval: EventInterval?
    var recurringFrequency: EventFrequency?
    var doNotDisturb: Bool?
    
    var nextOccurence: Date {
        let interval = self.recurringInterval
        let frequency = self.recurringFrequency
        let timeIntervalToNext = frequency?.timeIntervalToNext ?? 0 * Double(interval?.multiplier ?? 1)
        let nextDate = Date(timeIntervalSinceNow: timeIntervalToNext)
        return nextDate
    }
    
    let uid: String
    
    var dictionary: [String : Any] {
        return
            [ EventKey.name: name,
              EventKey.description: description as Any,
              EventKey.creatorUid: creatorUid,
              EventKey.participantsUid: participantsUid as Any,
              EventKey.type: type.rawValue,
              EventKey.status: status.rawValue,
              EventKey.space: space as Any,
              EventKey.date: date,
              EventKey.startTime: startTime as Any,
              EventKey.endTime: endTime as Any,
              EventKey.isRecurring: isRecurring,
              EventKey.recurringInterval : recurringInterval?.rawValue as Any,
              EventKey.recurringFrequency: recurringFrequency?.rawValue as Any,
              EventKey.doNotDisturb: doNotDisturb as Any,
              EventKey.uid: uid ]
    }
    
    init(name: String, description: String?,
         creatorUid: String, participantsUid: [String]?,
         type: EventType, status: EventStatus,
         space: String?,
         date: TimeInterval,
         startTime: Date?, endTime: Date?,
         isRecurring: Bool, recurringInterval: EventInterval?, recurringFrequency: EventFrequency?,
         doNotDisturb: Bool?,
         uid: String) {
        self.name = name
        self.description = description
        self.creatorUid = creatorUid
        self.participantsUid = participantsUid
        self.type = type
        self.status = status
        self.space = space
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.isRecurring = isRecurring
        self.recurringInterval = recurringInterval
        self.recurringFrequency = recurringFrequency
        self.doNotDisturb = doNotDisturb
        self.uid = uid
    }
    
    init?(withDict dict: [String : Any]) {
        guard let name =  dict[EventKey.name] as? String,
            let creatorUid =  dict[EventKey.creatorUid] as? String,
            let typeString = dict[EventKey.type] as? String,
            let type = EventType(rawValue: typeString),
            let statusString = dict[EventKey.status] as? String,
            let status = EventStatus(rawValue: statusString),
            let date = dict[EventKey.date] as? TimeInterval,
            let isRecurring = dict[EventKey.isRecurring] as? Bool,
            let uid = dict[EventKey.uid] as? String
            else { print(">>>\(#file) \(#line): guard let failed<<<"); return nil}
        
        if let description = dict[EventKey.description] as? String?,
            let desc = description {
            self.description = desc
        }
        
        if let participantsUid = dict[EventKey.participantsUid] as? [String]?,
            let participantsID = participantsUid {
            var participants = [InternalUser]()
            
            for participant in participantsID {
                InternalUserController.shared.fetchUser(withUid: participant) { (user) in
                    if let user = user {
                        participants.append(user)
                    }
                }
            }
            self.participantsUid = participantsID
            self.participants = participants
        }
        
        if let space = dict[EventKey.space] as? String? {
            self.space = space
        }
        
        if let startTime = dict[EventKey.startTime] as? Date? {
            self.startTime = startTime
        }
        if let endTime = dict[EventKey.endTime] as? Date? {
            self.endTime = endTime
        }
        
        if let recurringInterval = dict[EventKey.recurringInterval] as? String?,
            let interval = recurringInterval,
            let intervall = EventInterval(rawValue: interval) {
            self.recurringInterval = intervall
        }
        
        if let recurringFrequency = dict[EventKey.recurringFrequency] as? String?,
            let frequency = recurringFrequency,
            let frequencyy = EventFrequency(rawValue: frequency) {
            self.recurringFrequency = frequencyy
        }
        
        if let doNotDisturb = dict[EventKey.doNotDisturb] as? Bool? {
            self.doNotDisturb = doNotDisturb
        }
        
        self.creatorUid = creatorUid
        self.name = name
        self.type = type
        self.date = date
        self.status = status
        self.isRecurring = isRecurring
        self.uid = uid
        
        var creatr: InternalUser?
        InternalUserController.shared.fetchUser(withUid: creatorUid) { (user) in
            if let user = user {
                creatr = user
                self.creator = creatr
            }
        }
    }
}

extension Event {
    enum EventType: String {
        case task
        case event
    }
    
    enum EventStatus: String {
        case open
        case complete
    }
}
