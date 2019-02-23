//
//  PlaceController.swift
//  Roommate Tracker
//
//  Created by Greg Hughes on 1/14/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import Foundation
import Firebase

class PlaceController {
    
    static let shared = PlaceController(); private init() {}
    
    var currentPlace : Place?
    
    func createPlace(adminUid: String, placeName: String, homeAddress: String?, completion: @escaping (Place?)->()) {
        
        let dbref = FirebaseController.db.collection("places").document()
        let newPlace = Place(placeName: placeName, homeAddress: homeAddress, adminUid: [adminUid],  uid: dbref.documentID)
        newPlace.tenantsUid = [adminUid]
        
        FirebaseController.save(objectDict: newPlace.dictionary, to: dbref) { (success) in
            if success {
                completion(newPlace)
                return
            }
            completion(nil)
        }
    }
    
    func updatePlace(place: Place, completion: @escaping (Place?) -> Void) {
        
        let dbref = FirebaseController.db.collection("places").document(place.uid)
        FirebaseController.save(objectDict: place.dictionary, to: dbref) { (success) in
            if success {
                completion(place)
                return
            }
            completion(nil)
        }
    }
    
    func deletePlace(place: Place, completion: @escaping (Bool)->()) {
        FirebaseController.db.collection("places").document(place.uid).delete { (error) in
            if let error = error {
                print(">>>>>>> There was an error in \(#file): \(#function): \(#line) \(error) \(error.localizedDescription) <<<<<<<")
                completion(false)
                return
            }
            completion(true)
            print("Deleted successfully")
        }
    }
    
    func fetchPlace(withUid uid: String, completion: @escaping (Place?) -> ()) {
        let query = FirebaseController.db.collection("places").whereField("uid", isEqualTo: uid)
        FirebaseController.fetch(withQuery: query) { (places) in
            if !places.isEmpty {
                let place = Place(withDict: places[0].data())
                completion(place)
            } else {
                completion(nil)
            }
        }
    }
    
    func updatePlacename(toPlace place: Place, toName name: String, completion: @escaping (Place?) -> Void) {
        place.placeName = name
        updatePlace(place: place, completion: completion)
    }
    
    func updatePlaceAddress(toPlace place: Place, toAdress address: String, completion: @escaping (Place?) -> Void) {
        place.homeAddress = address
        updatePlace(place: place, completion: completion)
    }
    
    func updateAddAdminUid(toPlace place: Place, adminUid: String, completion: @escaping (Place?) -> Void) {
        place.adminUid.append(adminUid)
        updatePlace(place: place, completion: completion)
    }
    
    func updateDeleteAdminUid(toPlace place: Place, adminUid: String) {
        if place.adminUid.count > 1 {
            if let index = place.adminUid.index(of: adminUid) {
                place.adminUid.remove(at: index)
            } else {
                print("\(#file): \(#line) INDEX NOT FOUND")
            }
        } else {
            print("PLACE SHOULD HAVE AT LEAST 1 ADMIN")
        }
    }
    
    func updateAddTenantUid(toPlace place: Place, tenantUid: String, completion: @escaping (Place?) -> Void) {
        if let _ = place.tenantsUid {
            place.tenantsUid?.append(tenantUid)
        } else {
            place.tenantsUid = [tenantUid]
        }
        updatePlace(place: place, completion: completion)
    }
    
    func updateRemoveTenantUid(toPlace place: Place, tenantUid: String, completion: @escaping (Place?) -> Void) {
        if let tenants = place.tenantsUid,
            let index = tenants.index(of: tenantUid) {
            place.tenantsUid?.remove(at: index)
            updatePlace(place: place, completion: completion)
        }
    }
    
    func updateAddEventUid(toPlace place: Place, eventUid: String, completion: @escaping (Place?) -> Void) {
        place.eventsUid?.append(eventUid)
        updatePlace(place: place, completion: completion)
    }
    
    func updateRemoveEventUid(toPlace place: Place, eventUid: String, completion: @escaping (Place?) -> Void) {
        if let events = place.eventsUid,
            let index = events.index(of: eventUid) {
            place.eventsUid?.remove(at: index)
            updatePlace(place: place, completion: completion)
        }
    }
    
    func updateShoppingListUid(toPlace place: Place, shoppingListUid: String, completion: @escaping (Place?) -> Void) {
        place.shoppingListUid = shoppingListUid
        updatePlace(place: place, completion: completion)
    }
    
    func updateAddScheduledEventsUid(toPlace place: Place, eventUid: String, completion: @escaping (Place?) -> Void) {
        if let _ = place.scheduledEventsUid {
            place.scheduledEventsUid?.append(eventUid)
        } else {
            place.scheduledEventsUid = [eventUid]
        }
        
        updatePlace(place: place, completion: completion)
    }
    
    func updateRemoveScheduledEventsUid(toPlace place: Place, eventUid: String, completion: @escaping (Place?) -> Void) {
        if let events = place.scheduledEventsUid,
            let index = events.index(of: eventUid) {
            place.scheduledEventsUid?.remove(at: index)
            updatePlace(place: place, completion: completion)
        }
    }
    
    func updateAddSpaces(toPlace place: Place, space: String, completion: @escaping (Place?) -> Void) {
        if let _ = place.spaces {
            place.spaces?.append(space)
        } else {
            place.spaces = [space]
        }
        updatePlace(place: place, completion: completion)
    }
    
    func updateRemoveSpaces(toPlace place: Place, space: String, completion: @escaping (Place?) -> Void) {
        if let spaces = place.spaces,
            let index = spaces.index(of: space) {
            place.spaces?.remove(at: index)
            updatePlace(place: place, completion: completion)
        }
    }
    
    func updateAddInvitationsUid(toPlace place: Place, invitationUid: String, completion: @escaping (Place?) -> Void) {
        if let _ = place.invitationsUid {
            place.invitationsUid?.append(invitationUid)
        } else {
            place.invitationsUid = [invitationUid]
        }
        updatePlace(place: place, completion: completion)
    }
    
    func updateRemoveInvitationsUid(toPlace place: Place, invitationUid: String, completion: @escaping (Place?) -> Void) {
        if let invitations = place.invitationsUid,
            let index = invitations.index(of: invitationUid) {
            place.invitationsUid?.remove(at: index)
            updatePlace(place: place, completion: completion)
        }
    }
    
    func updateHomeRules(toPlace place: Place, homeRules: String, completion: @escaping (Place?) -> Void) {
        place.homeRules = homeRules
        updatePlace(place: place, completion: completion)
    }
    
    func updateWifiInformation(toPlace place: Place, wifiName: String?, wifiPassword: String?, completion: @escaping (Place?) -> Void) {
        place.wifiNetworkName = wifiName
        place.wifiNetworkPassword = wifiPassword
        updatePlace(place: place, completion: completion)
    }

}

//func evictTenant(fromPlace place: Place, tenant: InternalUser, completion: @escaping (Bool) -> ()) {
//
//    guard let index = place.tenantsUid?.index(of: tenant.uid) else { print(">>>\(#file) \(#line): guard let failed<<<"); completion(false); return }
//
//    place.tenantsUid?.remove(at: index)
//
//    let placeDbRef = FirebaseController.db.collection("places").document(place.uid)
//    FirebaseController.save(objectDict: place.dictionary, to: placeDbRef) { (success) in
//        completion(success)
//    }
//}

//func update(_ place: Place,
//            placename: String? = nil,
//            homeAddress: String? = nil,
//            adminUid: String? = nil,
//            addTenantsUid: [String]? = nil,
//            removeTenantsUid: [String]? = nil,
//            addTasksUid: [String]? = nil,
//            removeTasksUid: [String]? = nil,
//            shoppingListUid: String? = nil,
//            addScheduledEventsUid: [String]? = nil,
//            removeScheduledEventsUid: [String]? = nil,
//            addSpaces: [String]? = nil,
//            removeSpaces: [String]? = nil,
//            addInvitationsUid: [String]? = nil,
//            removeInvitationsUid: [String]? = nil,
//            homeRules: String? = nil,
//            wifiInformation: String? = nil
//    ) {
//}
