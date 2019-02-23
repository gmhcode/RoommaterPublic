//
//  DayEventsTableViewCell.swift
//  Roommater
//
//  Created by Greg Hughes on 1/21/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class DayEventsTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var eventNameLabel: UILabel!
    
    
    
    @IBOutlet weak var eventRoomLabel: UILabel!
    
    @IBOutlet weak var timeStartingLabel: UILabel!
    
    @IBOutlet weak var timeEndingLabel: UILabel!
    
    @IBOutlet weak var eventOwnerPicture: UIImageView!
    @IBOutlet weak var eventTypeView: UIView!
    
    var event : Event?{
        didSet{
            updateViews()
        }
    }
  
    func updateViews(){
        guard let event = event else { return }
        
        eventNameLabel.text = event.name
        eventRoomLabel.text = event.space
        timeStartingLabel.text = event.startTime?.asTimeString
        timeEndingLabel.text = event.endTime?.asTimeString
        
        
        
        //TODO: need a space property
        
        
        
    }

    
    
    
  

}
