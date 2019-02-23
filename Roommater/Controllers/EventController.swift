//
//  EventController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/18/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import Foundation

class EventController {
    
    static let shared = EventController(); private init() {}
    
    var events : [Event] = []
    
    func createEvent( name: String, description: String?, user: InternalUser,
                      participantsUid: [String]?,
                      type: Event.EventType, status: Event.EventStatus,
                      space: String?,
                      date: TimeInterval,
                      startTime: Date?,
                      endTime: Date?,
                      isRecurring: Bool,
                      recurringInterval: EventInterval?,
                      recurringFrequency: EventFrequency?,
                      doNotDisturb: Bool?,
                      completion: @escaping (Event?)->()){
        
        let dbref = FirebaseController.db.collection("events").document()
        
        let newEvent = Event(name: name,
                             description: description,
                             creatorUid: user.uid,
                             participantsUid: participantsUid,
                             type: type, status: status,
                             space: space,
                             date: date, startTime: startTime, endTime: endTime,
                             isRecurring: isRecurring, recurringInterval: recurringInterval, recurringFrequency: recurringFrequency,
                             doNotDisturb: doNotDisturb,
                             uid: dbref.documentID)
        
        FirebaseController.save(objectDict: newEvent.dictionary, to: dbref) { (success) in
            if success {
                self.events.append(newEvent)
                completion(newEvent)
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchEvent(withId eventId: String, completion: @escaping (Event?) -> Void) {
        
        let query = FirebaseController.db.collection("events").document(eventId)
        query.getDocument { (snapshot, error) in
            if let error = error {
                print(">>>>>>> There was an error in \(#file): \(#function): \(#line) \(error) \(error.localizedDescription) <<<<<<<")
                completion(nil)
                return
            }
            guard let snapshot = snapshot,
                let snapshotData = snapshot.data()
                else { print(">>>\(#file) \(#line): guard let failed<<<"); completion(nil); return }
            
            let event = Event(withDict: snapshotData)
            completion(event)
        }
    }

    
    func fetchEvents(withDateRangeStartingAt starting: TimeInterval, ending: TimeInterval, completion: @escaping ([Event]) -> Void) {
        let query = FirebaseController.db.collection("events").whereField("date", isGreaterThanOrEqualTo: starting).whereField("date", isLessThanOrEqualTo: ending)
        FirebaseController.fetch(withQuery: query) { (eventsQuery) in
            
            if !eventsQuery.isEmpty {
                let events = eventsQuery.compactMap{ Event(withDict: $0.data()) }
                completion(events)
            }
        }
    }
    
    func fetchEvents(withCreatorUid uid: String, completion: @escaping ([Event]) -> ()) {
        let query = FirebaseController.db.collection("events").whereField("creatorUid", isEqualTo: uid)
        FirebaseController.fetch(withQuery: query) { (eventsQuery) in
            if !eventsQuery.isEmpty {
                let events = eventsQuery.compactMap{ Event(withDict: $0.data()) }
                completion(events)
            }
        }
    }
    
    func fetchEvents(withType type: Event.EventType, completion: @escaping ([Event]) -> Void) {
        let query = FirebaseController.db.collection("events").whereField("type", isEqualTo: type.rawValue)
        FirebaseController.fetch(withQuery: query) { (eventsQuery) in
            if !eventsQuery.isEmpty {
                let events = eventsQuery.compactMap{ Event(withDict: $0.data()) }
                completion(events)
            }
        }
    }
    
    func fetchEvents(forUserUid userUid: String, withType type: Event.EventType, completion: @escaping ([Event]) -> Void) {
        let query = FirebaseController.db.collection("events").whereField("participantsUid", arrayContains: userUid).whereField("type", isEqualTo: type.rawValue)
        
        FirebaseController.fetch(withQuery: query) { (eventsQuery) in
            if !eventsQuery.isEmpty {
                let events = eventsQuery.compactMap{ Event(withDict: $0.data()) }
                completion(events)
            }
        }
    }
    

    func updateEvent(_ event: Event, completion: @escaping (Event?) -> Void) {
        
        let dbref = FirebaseController.db.collection("events").document(event.uid)
    
        FirebaseController.save(objectDict: event.dictionary, to: dbref) { (success) in
            if success {
                completion(event)
            } else {
                completion(nil)
            }
        }
    }
    
    func updateEventDescription(toEvent event: Event, withDescription description: String, completion: @escaping (Event?) -> Void) {
        
        event.description = description
        updateEvent(event, completion: completion)
    }
    
    func updateAddEventParticipantUid(toEvent event: Event, participantUid: String, completion: @escaping (Event?) -> Void) {
        if let _ = event.participantsUid {
            event.participantsUid?.append(participantUid)
        } else {
            event.participantsUid = [participantUid]
        }
        updateEvent(event, completion: completion)
    }
    
    func updateDeleteEventParticipantsUid(toEvent event: Event, participantUid: String, completion: @escaping (Event?) -> Void) {
        
        if let participants = event.participantsUid,
            let index = participants.index(of: participantUid) {
            event.participantsUid?.remove(at: index)
            updateEvent(event, completion: completion)
        }
    }
    
    func updateDate(toEvent event: Event, date: TimeInterval, completion: @escaping (Event?) -> Void) {
        
        event.date = date
        updateEvent(event, completion: completion)
    }
    
    func updateStartTime(toEvent event: Event, startTime: Date?, completion: @escaping (Event?) -> Void) {
        
        event.startTime = startTime
        updateEvent(event, completion: completion)
    }
    
    func updateEndTime(toEvent event: Event, endTime: Date?, completion: @escaping (Event?) -> Void) {
        
        event.endTime = endTime
        updateEvent(event, completion: completion)
    }
    
    func updateRecurrence(toEvent event: Event, isRecurring: Bool?, recurringInterval: EventInterval, recurringFrequency: EventFrequency?, completion: @escaping (Event?) -> Void) {
        
        if let isRecurring = isRecurring {
            event.isRecurring = isRecurring
            event.recurringInterval = recurringInterval
            event.recurringFrequency = recurringFrequency
            updateEvent(event, completion: completion)
        }
    }
    
    func updateEventStatus(_ event: Event, _ status: Event.EventStatus, completion: @escaping (Event?) -> Void) {
        
        event.status = status
        updateEvent(event, completion: completion)
    }
    
    func updateEventSpace(_ event: Event, space: String?, completion: @escaping (Event?) -> Void) {
        event.space = space
        updateEvent(event, completion: completion)
    }
    
    func updateEventDoNotDisturb(_ event: Event, doNotDisturb: Bool?, completion: @escaping (Event?) -> Void){
        event.doNotDisturb = doNotDisturb
        updateEvent(event, completion: completion)
    }

    func deleteEvent(event: Event, completion: @escaping (Bool) -> ()) {
        FirebaseController.db.collection("events").document(event.uid).delete()
            { (error) in
                if let error = error {
                    print(">>>>>>> There was an error in \(#file): \(#function): \(#line) \(error) \(error.localizedDescription) <<<<<<<")
                    completion(false)
                    return
                }
                completion(true)
                print("Deleted successfully")
        }
    }
}
