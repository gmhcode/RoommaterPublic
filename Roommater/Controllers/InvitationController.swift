//
//  InvitationController.swift
//  Roommater
//
//  Created by Drew on 1/18/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import Foundation

class InvitationController {
    
    static let shared = InvitationController(); private init() {}
    
    func createInvitation(place: Place, completion: @escaping (Bool)->()) {
        
        let dbref = FirebaseController.db.collection("invitations").document()
        let newInvite = Invitation(toPlace: place, uid: dbref.documentID)
        
        FirebaseController.save(objectDict: newInvite.dictionary, to: dbref) { (success) in
            if success {
                if let _ = PlaceController.shared.currentPlace?.invitationsUid {
                    PlaceController.shared.currentPlace?.invitationsUid?.append(newInvite.inviteCode)
                    guard let currentPlace = PlaceController.shared.currentPlace else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
                    PlaceController.shared.updatePlace(place: currentPlace, completion: { (place) in
                        guard let place = place else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
                        PlaceController.shared.currentPlace = place
                    })
                    
                } else {
                    PlaceController.shared.currentPlace?.invitationsUid = [newInvite.inviteCode]
                    guard let currentPlace = PlaceController.shared.currentPlace else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
                    PlaceController.shared.updatePlace(place: currentPlace, completion: { (place) in
                        guard let place = place else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
                        PlaceController.shared.currentPlace = place
                    })
                }
                
    
            }
            completion(success)
        }
    }
    
    
    
    func fetchInvitationToPlace(withCode code: String, completion: @escaping (String?)->()){
        
        let query = FirebaseController.db.collection("invitations").whereField("inviteCode", isEqualTo: code)
        
        FirebaseController.fetch(withQuery: query) { (snapshots) in
            if !snapshots.isEmpty {
                guard let invitation = Invitation(withDict: snapshots[0].data()) else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
                self.deleteInvitation(invitation: invitation, completion: { (success) in
                    if success {
                        completion(invitation.placeUid)
                        return
                    }
                    completion(nil)
                })
                
            } else {
                print("\(#file): \(#function): \(#line) DATA EMPTY" )
                completion(nil)
            }
        }
    }
    
    func deleteInvitation(invitation: Invitation, completion: @escaping (Bool) -> ()) {
        
        FirebaseController.db.collection("invitations").document(invitation.uid).delete { (error) in
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

