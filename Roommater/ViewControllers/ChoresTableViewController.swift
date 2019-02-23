//
//  ChoresTableViewController.swift
//  Roommater
//
//  Created by Drew on 1/29/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit
import EventKit
import JTAppleCalendar

class ChoresTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var chore: Event?
    
    @IBOutlet weak var repeatsStackView: UIStackView!
    @IBOutlet weak var repeatRightStack: UIStackView!
    @IBOutlet weak var repeatLeftStack: UIStackView!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var EventNameTextField: UITextField!
    @IBOutlet weak var EventDescriptionTextField: UITextField!
    @IBOutlet weak var StartTimeDatePicker: UIDatePicker!
    @IBOutlet weak var EndTimeDatePicker: UIDatePicker!
    @IBOutlet weak var IntervalPicker: UIPickerView!
    @IBOutlet weak var FrequencyPicker: UIPickerView!
    @IBOutlet weak var ReminderPicker: UIPickerView!
    @IBOutlet weak var AssignPicker: UIPickerView!
    @IBOutlet weak var repeatToggleSwitch: UISwitch!
    @IBOutlet weak var remindToggleSwich: UISwitch!
    @IBOutlet weak var assignToggleSwitch: UISwitch!
    @IBOutlet weak var rotateToggleSwitch: UISwitch!
    
    var intervalPickerData: [String] = []
    var frequencyPickerData: [String] = []
    var reminderData: [String] = []
    var tenantsData: [String] = ["Everyone"]
    
    var intervalPickerReturn: String = "Every"
    var frequencyPickerReturn: String = "Day"
    var reminderPickerReturn: String = "Day before Event"
    var tenantPickerReturn: String = "Everyone" {
        didSet {
            print("\(tenantsData) |||| \(tenantPickerReturn)")
        }
    }
    
    var repeatToggle: Bool = false
    var remindToggle: Bool = false
    var assignToggle: Bool = false
    var rotateToggle: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let place = PlaceController.shared.currentPlace,
            let tenants = place.tenants
            else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
        
        self.IntervalPicker.delegate = self
        self.IntervalPicker.dataSource = self
        self.FrequencyPicker.delegate = self
        self.FrequencyPicker.dataSource = self
        self.ReminderPicker.delegate = self
        self.ReminderPicker.dataSource = self
        self.AssignPicker.delegate = self
        self.AssignPicker.dataSource = self
        repeatToggleSwitch.isOn = repeatToggle
        remindToggleSwich.isOn = remindToggle
        assignToggleSwitch.isOn = assignToggle
        rotateToggleSwitch.isOn = rotateToggle
        
        intervalPickerData = ["Every", "Every Other", "Every Third"]
        frequencyPickerData = ["Day", "Week", "Month"]
        reminderData = ["Day before Event", "Day of Event"]
        tenantsData += tenants.compactMap{ $0.fullname }
        
        IntervalPicker.isHidden = true
        FrequencyPicker.isHidden = true
        ReminderPicker.isHidden = true
        AssignPicker.isHidden = true
    }
    
    @IBAction func SaveButtonTapped(_ sender: UIBarButtonItem) {
        guard let currentUser = InternalUserController.shared.loggedInUser else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
        
        let tenantsUidForEvent = matchTenantsNamesWithCurrentTenants(tenantName: tenantPickerReturn)
        
        let eventDateComponents = Calendar.current.dateComponents([.month, .day, .year], from: DatePicker.date)
        guard let formattedDate = Calendar.current.date(from: eventDateComponents) else { return }
        
        EventController.shared.createEvent(
            name: EventNameTextField?.text ?? "Untitled",
            description: EventDescriptionTextField?.text ?? "No Description",
            user: currentUser,
            participantsUid: tenantsUidForEvent,
            type: Event.EventType.task,
            status: Event.EventStatus.open,
            space: nil,
            date: formattedDate.timeIntervalSince1970,
            startTime: combineDateTime(baseDate: DatePicker.date , appendixTime: StartTimeDatePicker.date),
            endTime: combineDateTime(baseDate: DatePicker.date, appendixTime: EndTimeDatePicker.date),
            isRecurring: repeatToggle,
            recurringInterval: EventInterval(rawValue: intervalPickerReturn),
            recurringFrequency: EventFrequency(rawValue: frequencyPickerReturn),
            doNotDisturb: nil
            )
        { (event) in
            // TODO: Alert if event isn't saved (guard let fails)
                guard let event = event else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
                self.chore = event
            print(event.name, event.participantsUid)
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func repeatSwitchTapped(_ sender: Any) {
        repeatToggle.toggle()
        UIView.animate(withDuration: 0.5) {
            self.FrequencyPicker.isHidden = !self.repeatToggle
            self.IntervalPicker.isHidden = !self.repeatToggle
            self.tableView.layoutIfNeeded()
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    @IBAction func remindSwitchTapped(_ sender: UISwitch) {
        remindToggle.toggle()
        UIView.animate(withDuration: 0.5) {
            self.ReminderPicker.isHidden = !self.remindToggle
            self.tableView.layoutIfNeeded()
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    @IBAction func assignSwitchTapped(_ sender: Any) {
        assignToggle.toggle()
        UIView.animate(withDuration: 0.5) {
            self.AssignPicker.isHidden = !self.assignToggle
            self.tableView.layoutIfNeeded()
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return intervalPickerData.count
        } else if pickerView.tag == 2 {
            return frequencyPickerData.count
        } else if pickerView.tag == 3 {
            return reminderData.count
        } else if pickerView.tag == 4 {
            return tenantsData.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return intervalPickerData[row]
        } else if pickerView.tag == 2 {
            return frequencyPickerData[row]
        } else if pickerView.tag == 3 {
            return reminderData[row]
        } else if pickerView.tag == 4 {
            return tenantsData[row]//.fullname
        } else {
            return "NONE"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            self.intervalPickerReturn = self.intervalPickerData[row]
        } else if pickerView.tag == 2 {
            self.frequencyPickerReturn = self.frequencyPickerData[row]
        } else if pickerView.tag == 3 {
            self.reminderPickerReturn = self.reminderData[row]
        } else if pickerView.tag == 4 {
            self.tenantPickerReturn = self.tenantsData[row]//.fullname
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0
            || indexPath.row == 1
            || indexPath.row == 2
            || indexPath.row == 3
        {
            return view.bounds.width * 0.25
        }
        
        if indexPath.row == 4 {
            if !repeatToggle {
                return view.bounds.width * 0.15
            } else {
                return view.bounds.width * 0.45
            }
        }
        
        if indexPath.row == 5 {
            if !remindToggle {
                return view.bounds.width * 0.15
            } else {
                return view.bounds.width * 0.30
            }
        }
        
        if indexPath.row == 6 {
            if !assignToggle {
                return view.bounds.width * 0.15
            } else {
                return view.bounds.width * 0.40
            }
        }
        
        if indexPath.row == 7 {
            return view.bounds.width * 0.20
        }
        return 45
    }
}

extension ChoresTableViewController {
    func combineDateTime(baseDate: Date, appendixTime: Date) -> Date? {
        
        // Slice hour and minute from appendixTime
        // Combine baseDate and appendixTime
        let appendixComponents = Calendar.current.dateComponents([.hour, .minute], from: appendixTime)
        let combinedTime = Calendar.current.date(bySettingHour: appendixComponents.hour!, minute: appendixComponents.minute!, second: 0, of: baseDate)
        
        return combinedTime
    }
    
    func matchTenantsNamesWithCurrentTenants(tenantName: String) -> [String] {
        guard let place = PlaceController.shared.currentPlace,
            let tenants = place.tenants
            else { print(">>>\(#file) \(#line): guard let failed <<<"); return []}
        
        if !assignToggle {
            return []
        } else {
            return tenants.compactMap{$0.uid}
        }
        
        if tenantName == "Everyone" {
            if let tenantsUids = place.tenantsUid {
                return tenantsUids
            }
        }
        
        var tenantsUid : [String] = []
        for tenant in tenants {
            if tenant.fullname == tenantName {
                tenantsUid.append(tenant.uid)
            }
        }
        
        return tenantsUid
    }
}
