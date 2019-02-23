//
//  EditEventsTableViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/21/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {

    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventRoomLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    @IBOutlet weak var dateContentView: UIView!
    @IBOutlet weak var titleContentView: UIView!
    @IBOutlet weak var roomContentView: UIView!
    @IBOutlet weak var timeContentView: UIView!
    
    
    
    
    
    var event : Event?
    var eventDate : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        updateViews()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let event = event,
        let eventStartTime = event.startTime?.asTimeString,
        let eventEndTime = event.endTime?.asTimeString
            else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
         let eventDate = Date(timeIntervalSince1970: event.date)

        eventDateLabel.text = "\(eventDate.asString)"
        eventNameLabel.text = event.name
        eventRoomLabel.text = event.space
        eventTimeLabel.text = "\(eventStartTime) - \(eventEndTime)"
    }

    // MARK: - Table view data source

    func updateViews(){
        
        dateContentView.addGrayUnderline()
        titleContentView.addGrayUnderline()
        roomContentView.addGrayUnderline()
        timeContentView.addGrayUnderline()
        
        guard let event = event,
            let eventStartTime = event.startTime?.asTimeString,
            let eventEndTime = event.endTime?.asTimeString,
            let eventDate = eventDate else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        eventDateLabel.text = "\(eventDate.asString)"
        eventNameLabel.text = event.name
        eventRoomLabel.text = event.space
        eventTimeLabel.text = "\(eventStartTime) - \(eventEndTime)"
    }

   

    
   
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editEvent"{
            
            let destinationVC = segue.destination as? EditEventTableViewController
            destinationVC?.event = event
            destinationVC?.date = eventDate
            
        }
    }
    
    
}
