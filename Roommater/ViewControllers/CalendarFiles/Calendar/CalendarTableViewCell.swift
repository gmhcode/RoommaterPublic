//
//  CalanderTableViewCell.swift
//  Roommater
//
//  Created by Greg Hughes on 1/20/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventSpaceLabel: UILabel!
    @IBOutlet weak var beginningTimeLabel: UILabel!
    @IBOutlet weak var endingTimeLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var doNotDisturbImage: UIImageView!
    @IBOutlet weak var eventColorBar: UIView!
    
//    TODO need to be able to access user profile picture through event
    
    var event : Event? {
        didSet {
            self.setlabels()
            updateViews()
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width/2
        profilePicture.layer.masksToBounds = true
    }
   
    func updateViews(){
        guard let event = event else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

            InternalUserController.shared.fetchUser(withUid: event.creatorUid) { (user) in
                guard let user = user else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
                
                FirebaseStorageController.fetchImage(forUser: user) { (image) in
                    self.profilePicture.image = image
                    
                }
            }

        

        
        
        if event.doNotDisturb == true {
            doNotDisturbImage.image = UIImage(named: "DND")
        } else {
            doNotDisturbImage.image = nil 
        }
        
        if event.type == .task {
            eventColorBar.backgroundColor = UIColor(red: 31, green: 182, blue: 255)
            event.status == .open ? incompleteTaskView() : completeTaskView()
            
            
            
        } else {
            eventColorBar.backgroundColor = UIColor(red: 255, green: 219, blue: 0)
            eventSpaceLabel.textColor = UIColor(red: 211, green: 211, blue: 211)
            
        }
    }
    
    
    func incompleteTaskView(){
        eventSpaceLabel.textColor = UIColor.red
        eventSpaceLabel.text = "OPEN TASK"
    }
    func completeTaskView(){
        eventSpaceLabel.text = "COMPLETE"
        eventSpaceLabel.textColor = UIColor(red: 55, green: 221, blue: 130)
    }
    
    func setlabels(){
        self.eventNameLabel.text = event?.name
        self.eventSpaceLabel.text = event?.space
        self.beginningTimeLabel.text = event?.startTime?.asTimeString
        self.endingTimeLabel.text = event?.endTime?.asTimeString
    }
}
