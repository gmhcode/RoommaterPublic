//
//  TaskTableViewCell.swift
//  Roommater
//
//  Created by Drew on 1/28/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

protocol TaskTableViewCellDelegate: class {
    func taskButton(cell: TaskTableViewCell)
}

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var taskDateLabel: UILabel!
    @IBOutlet weak var taskDoneButtonFace: UIButton!
    
    weak var delegate : TaskTableViewCellDelegate?
    
    var task: Event? {
        didSet {
            updateViews()
        }
    }
    
    @IBAction func taskDoneButtonTapped(_ sender: UIButton) {
        guard let task = task else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
        if task.status == Event.EventStatus.open {
            task.status = .complete
        } else {
            task.status = .open
        }
        
        EventController.shared.updateEventStatus(task, task.status) { (task) in
            if let task = task {
                self.task = task
                print("Task updated")
                DispatchQueue.main.async {
                    self.delegate?.taskButton(cell: self)
                }
            }
        }
    }
    
    func updateViews() {
        guard let task = task else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
        taskLabel.font = UIFont(name: "Roboto-Regular", size: 16)
        taskDateLabel.font = UIFont(name: "Roboto-Bold", size: 12)
        taskDateLabel.textColor = UIColor(red: 211, green: 211, blue: 211)
        
        if task.status == Event.EventStatus.open {
            let imageOn = UIImage(named: "groupOpen")
            taskDoneButtonFace.setImage(imageOn, for: .normal)
        } else {
            let imageOff = UIImage(named: "groupComplete")
            taskDoneButtonFace.setImage(imageOff, for: .normal)
        }
        
        self.taskLabel.text = task.name
        self.taskDateLabel.text = Date(timeIntervalSince1970: task.date).asString.uppercased()
        // TODO: CHANGE BUTTON IMAGE @ UPDATEVIEWS
    }
    
    
}
