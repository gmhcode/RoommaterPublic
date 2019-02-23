//
//  EditScheduledRoomTableViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/22/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class EditEventTableViewController: UITableViewController {
    
    var space = ""
    var place = PlaceController.shared.currentPlace
    var event : Event?
    var date : Date?
    var currentUser = InternalUserController.shared.loggedInUser
    
    
    @IBOutlet weak var eventNameTextFieldView: UIView!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var roomContentView: UIView!
    @IBOutlet weak var descriptionContentView: UIView!
    @IBOutlet weak var startAndEndContentView: UIView!
    
    
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var spacePicker: UIPickerView!
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    @IBOutlet weak var timeStartDatePicker: UIDatePicker!
    @IBOutlet weak var timeEndDatePicker: UIDatePicker!
    @IBOutlet weak var dayDatePicker: UIDatePicker!
    
    
    var eventDate : Date?
    var eventStartingTime : Date?
    var eventEndingTime : Date?
    
    var roomCellIsToggled = false
    
    var spacesTest = [1,2,3,4,5,6,7]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Events"

        spacePicker.delegate = self
        spacePicker.dataSource = self
        setDatePickers()
        setPickerView()
        setUpLabels()
        
        spacePicker.isHidden = true
        
        
        
        
        
        
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
        updateTimes()
        print("♊️\(eventDate)")
        
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        guard let event = event else { return }
        
     
        
        
        EventController.shared.deleteEvent(event: event) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    
    //save button
    @IBAction func saveButtonTapped(_ sender: Any) {
        updateTimes()
        setDatePickers()
        
        
        if eventNameTextField.text == "" {
            eventNameTextField.text = "default event name"
        }
        
        guard let eventName = eventNameTextField.text,
            let user = currentUser,
            let date = eventDate,
            let place = place else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return }
        
        
        let eventDateComponents = Calendar.current.dateComponents([.month, .day, .year], from: date)
        guard let formattedDate = Calendar.current.date(from: eventDateComponents) else { return }
        
        
        event?.date = formattedDate.timeIntervalSince1970
        event?.name = eventName
        
        event?.space = space
        event?.description = descriptionTextView.text
        
        event?.startTime = eventStartingTime
        event?.endTime = eventEndingTime
        



        EventController.shared.updateEvent(event!) { (event) in
            self.event = event
            
        }
        
        
        
        
        navigationController?.popViewController(animated: true)
        
        
    }
   
    
    
    
}


extension EditEventTableViewController {
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
        
        
        
        //        print(combinedStart)
        //        print("❇️\(combinedStart.asTimeString)")
        print("♊️\(eventDate)")
    }
    
    func setDatePickers(){
        //        NSTimeZone.resetSystemTimeZone()
        //        timeEndDatePicker.calendar.timeZone = .autoupdatingCurrent
        
        guard let event = event,
            let eventStartTime = event.startTime,
            let eventEndTime = event.endTime,
            let date = date,
            let place = place else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

        
        
        timeEndDatePicker.date = eventEndTime
        timeEndDatePicker.setDate(timeEndDatePicker.date, animated: true)
    
        
        
        
        timeStartDatePicker.date = eventStartTime
        timeStartDatePicker.setDate(timeStartDatePicker.date, animated: true)
        
        
        dayDatePicker.date = date
        dayDatePicker.setDate(Date(), animated: true)
        
        
        
        
    }
    func setUpLabels(){
        
        
        
        eventNameTextField.borderStyle = .none
        eventNameTextField.addGrayUnderline()
        roomNameLabel.addGrayUnderline()
        descriptionContentView.addGrayUnderline()
        
        
        
        
        guard let event = event else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        roomNameLabel.text = event.space
        if event.name != "" {
        eventNameTextField.text = event.name
        }
        if event.description != "" {
            descriptionTextView.text = event.description
        }
        
        roomNameLabel.text = event.space
        
        
    }
    func setPickerView(){
        
        let index = findingSpaces()
        
        spacePicker.selectRow(index, inComponent:0, animated:true)
        
    }
}


//room picker functionality
extension EditEventTableViewController: UIPickerViewDelegate,UIPickerViewDataSource  {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return place?.spaces?.count ?? 0
        //        return spacesTest.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let spaces = place?.spaces,
            let eventSpace = event?.space else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return ""}
        
        
        
        
        space = spaces[row]
        roomNameLabel.text = space
        
        return place?.spaces?[row]
        //        return String(spacesTest[row])
    }
    
    
    
    func findingSpaces() -> Int{
        guard let spaces = place?.spaces,
            let eventSpace = event?.space else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return 0}
        
        var index = 0
        for matchingSpace in spaces{
            
            if matchingSpace == eventSpace{
                return index
            }else {
                index += 1
            }
        }
        return index
    }
    
}
