//
//  CustomCalendarCell.swift
//  Roommater
//
//  Created by Greg Hughes on 1/20/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit
import JTAppleCalendar
class CalendarCell: JTAppleCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var dot: UIView!
    
    
    override func awakeFromNib() {
        updateViews()
    }
    
    func updateViews(){
        selectedView.layer.cornerRadius = selectedView.frame.size.width/2
    }
    
    
}
