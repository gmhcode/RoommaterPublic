//
//  DayEventsTableViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/21/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class DayEventsTableViewController: UITableViewController {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var events: [Event]?
    var eventsDate : Date?
    
    //TODO: shouldnt events be optional? 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleSetup()
        
        let calendarTVCNib = UINib(nibName: "CalendarEventCell", bundle: nil)
        tableView.register(calendarTVCNib, forCellReuseIdentifier: "dayEventCell")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        titleSetup()
        
        let calendarTVCNib = UINib(nibName: "CalendarEventCell", bundle: nil)
        tableView.register(calendarTVCNib, forCellReuseIdentifier: "dayEventCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayEventCell", for: indexPath) as? CalendarTableViewCell,
            let events = events
            else { return UITableViewCell() }
     
        cell.event = events[indexPath.row]
        return cell
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "eventTableSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "eventTableSegue"{
            
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as?  EventTableViewController,
                let events = events,
                let eventsDate = eventsDate else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            
            let eventTakeOff = events[indexPath.row]
            let dateTakeOff = eventsDate
            
            destinationVC.event = eventTakeOff
            destinationVC.eventDate = dateTakeOff
            

        }
    }
    
    func titleSetup(){
        
        dateLabel.text = eventsDate?.asString
//        var attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "System", size: 18)! ]
       
    }
}

