//
//  ScheduleARoomTableViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/21/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class ScheduleARoomTableViewController: UITableViewController{
    
   
    
    
    @IBOutlet weak var spacePicker: UIPickerView!
    
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var doNotDisturb: UISwitch!
    
    
    @IBOutlet weak var timeStartDatePicker: UIDatePicker!
    @IBOutlet weak var timeEndDatePicker: UIDatePicker!
    @IBOutlet weak var dayDatePicker: UIDatePicker!

    var place = PlaceController.shared.currentPlace
    var events = EventController.shared.events
    var currentUser = InternalUserController.shared.loggedInUser
    
    var pickedSpace : String = ""
    
    var eventDate : Date?
    var eventStartingTime : Date?
    var eventEndingTime : Date?
    
    var roomCellIsToggled = false
    var spacesTest = [1,2,3,4,5,6,7]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDatePickers()
        spacePicker.delegate = self
        spacePicker.dataSource = self
        spacePicker.isHidden = true
        
        roomNameLabel.text = place?.placeName
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 105
        }
        if indexPath.row == 1{
            return 66
        }
        if indexPath.row == 2{
            if !roomCellIsToggled{
                
                return view.bounds.width * 0.15
            }
            else {return view.bounds.width * 0.50}
        }
        if indexPath.row == 3{
            return 164
        }
        if indexPath.row == 4{
            return 122
        }
        if indexPath.row == 5{
            return 153
        }
        return 75
  }
   
   //space picker
    @IBAction func spacePickerButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            
            self.roomCellIsToggled.toggle()
            self.spacePicker.isHidden.toggle()
            
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            
        }
    }
    
    @IBAction func doNotDisturbSwitchTapped(_ sender: Any) {
       
       doNotDisturb.isOn.toggle()
       
    }
    
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    func setDatePickers(){

        timeEndDatePicker.date = Date(timeInterval: 120, since: Date())
        timeEndDatePicker.setDate(timeEndDatePicker.date, animated: true)
        

        timeStartDatePicker.date = Date(timeInterval: 1, since: Date())
        timeStartDatePicker.setDate(timeStartDatePicker.date, animated: true)
        

        dayDatePicker.date = Date(timeInterval: 1, since: Date())
        dayDatePicker.setDate(Date(), animated: true)
        

    }
    
    //save button
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        updateTimes()
        
        if eventNameTextField.text == "" {
            eventNameTextField.text = "default event name"
        }
        
        guard let eventName = eventNameTextField.text,
            let user = currentUser,
            let date = eventDate,
            let place = place else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return }
        
        
        let eventDateComponents = Calendar.current.dateComponents([.month, .day, .year], from: date)
        guard let formattedDate = Calendar.current.date(from: eventDateComponents) else { return }
        
        EventController.shared.createEvent(name: eventName, description: descriptionTextView.text, user: user, participantsUid: [user.uid], type: .event, status: .open, space: pickedSpace, date: formattedDate.timeIntervalSince1970, startTime: eventStartingTime, endTime: eventEndingTime, isRecurring: false, recurringInterval: nil, recurringFrequency: nil, doNotDisturb: doNotDisturb.isOn) { (event) in
            
            if let event = event {
//                PlaceController.shared.currentPlace?.scheduledEvents = EventController.shared.events
                PlaceController.shared.updateAddScheduledEventsUid(toPlace: place, eventUid: event.uid, completion: { (place) in
                    guard let place = place else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
                     PlaceController.shared.currentPlace = place
                    
                    if let navController = self.navigationController {
                        navController.popViewController(animated: true)
                    }
                })
            }
        }
    }
}


//time picker functionality
extension ScheduleARoomTableViewController{
    //setting event variables
    func updateTimes(){
        
        guard timeStartDatePicker.calendar != nil,
            timeEndDatePicker.calendar != nil,
            dayDatePicker.calendar != nil else { return }
        
        eventDate = dayDatePicker.date
        eventStartingTime = timeStartDatePicker.date
        eventEndingTime = timeEndDatePicker.date
        //        print(eventDate!)
        //        print(eventEndingTime!)
       
        
        let eventEndTimeCompoenents = Calendar.current.dateComponents([.hour, .minute], from: eventEndingTime!)
        //^^ breaks eventEndingTime into only hours and minutes
        let combinedEndTime = Calendar.current.date(bySettingHour: eventEndTimeCompoenents.hour!, minute: eventEndTimeCompoenents.minute!, second: 0, of: eventDate!)
        //^^ gives eventDate the hours and minutes of eventEndingTime
        
        
        
        let startTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: eventStartingTime!)
        let combinedStartTime = Calendar.current.date(bySettingHour: startTimeComponents.hour!, minute: startTimeComponents.minute!, second: 0, of: eventDate!)
        
        
        
        guard let combinedStart = combinedStartTime,
            let combinedEnd = combinedEndTime else { return }
        
        eventEndingTime = combinedEnd
        eventStartingTime = combinedStart
        
        
   
        print("♊️\(eventDate)")
    }
    
}

//room picker functionality
extension ScheduleARoomTableViewController: UIPickerViewDelegate,UIPickerViewDataSource  {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return place?.spaces?.count ?? 0
//        return spacesTest.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let spaces = place?.spaces else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return ""}
        
        pickedSpace = spaces[row]
        roomNameLabel.text = pickedSpace
        return place?.spaces?[row]
        
//        return String(spacesTest[row])
    }
}
