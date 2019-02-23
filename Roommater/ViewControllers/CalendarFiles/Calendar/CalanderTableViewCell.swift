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
    
    @IBOutlet weak var eventColorBar: UIView!
    @IBOutlet weak var internalUserPicture: UIImageView!
    
//    TODO need to be able to access user profile picture through event
    var event : Event? {
        didSet {
            updateViews()
        }
    }
    
    
   
    func updateViews(){
        guard let event = event else { return }
        
        eventNameLabel.text = event.name
        eventSpaceLabel.text = event.space
        beginningTimeLabel.text = event.startTime?.asString
        endingTimeLabel.text = event.endTime?.asTimeString
        
        
        
        //TODO: need a space property
        
        
        
    }

   

}
