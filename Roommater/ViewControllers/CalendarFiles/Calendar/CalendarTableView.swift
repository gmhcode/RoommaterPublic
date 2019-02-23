//
//  CalendarTableView.swift
//  Roommater
//
//  Created by Greg Hughes on 1/20/19.
//  Copyright © 2019 Dre. All rights reserved.
//
import UIKit
import JTAppleCalendar

extension CalendarViewController {
    
    //TODO: perform fetch request on datesWithEvents
    //TODO: create an event list in a Date class
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dateSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let dateSection = dateSections[section]
        guard let events = eventsFromServer[dateSection] else { return 0 }
        
        return events.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "dayEventCell", for: indexPath) as? CalendarTableViewCell
        
        let dateSection = dateSections[indexPath.section]
        guard let events = eventsFromServer[dateSection] else { return UITableViewCell() }
        let event = events[indexPath.row]
        cell?.event = event
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.textColor = UIColor.lightGray
        headerLabel.text = "    \(dateSections[section].asString.uppercased())"

        return headerLabel
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "eventTableSegue", sender: nil)
    }
}
