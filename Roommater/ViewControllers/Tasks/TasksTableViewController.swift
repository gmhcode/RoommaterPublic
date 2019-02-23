//
//  TasksTableViewController.swift
//  Roommater
//
//  Created by Drew on 1/28/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class TasksTableViewController: UITableViewController, TaskTableViewCellDelegate {
    
    let currentUser = InternalUserController.shared.loggedInUser
    
    var tasksSectionsNames = ["OPEN TASKS", "COMPLETED TASKS"]
    var tasks : [Event]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var tasksTracker: [[Event]] {
        var taskTracker: [[Event]] = [[], []]
        guard let tasks = tasks else { print(">>>\(#file) \(#line): guard let failed <<<"); return [] }
        for task in tasks {
            if task.status == Event.EventStatus.open {
                taskTracker[0].append(task)
            } else {
                taskTracker[1].append(task)
            }
        }
        return taskTracker
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEvents { (events) in
            if !events.isEmpty {
                self.tasks = events
            }
        }
        
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Nunito-SemiBold", size: 28)!]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchEvents { (events) in
            if !events.isEmpty {
                self.tasks = events
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return tasksTracker.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasksTracker[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        cell.delegate = self
        cell.task = tasksTracker[indexPath.section][indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 120
        }
        return 45
    }
    
    func taskButton(cell: TaskTableViewCell) {
        fetchEvents { (events) in
            if !events.isEmpty {
                self.tasks = events
            }
        }
        tableView.reloadData()
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        return tasksSectionsNames[section]
//    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView()
        let headerLabel = UILabel()
        let separatorView = UIView(frame: CGRect(x: tableView.separatorInset.left, y: containerView.frame.height + 65, width: tableView.frame.width - tableView.separatorInset.right - tableView.separatorInset.left, height: 1))
        separatorView.backgroundColor = UIColor(red: 237, green: 237, blue: 237)
        
        
        containerView.addSubview(headerLabel)
        headerLabel.backgroundColor = UIColor.clear
        headerLabel.font = UIFont(name: "Roboto-Bold", size: 14)
        if section == 0 {
            headerLabel.textColor = UIColor(red: 255, green: 157, blue: 0)
        } else {
            headerLabel.textColor = UIColor(red: 55, green: 221, blue: 130)
        }
        headerLabel.text = tasksSectionsNames[section]
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
//        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24).isActive = true
        
        if section == 0 {
            headerLabel.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 25).isActive = true
        } else {
            containerView.addSubview(separatorView)
//            containerView.addSubview(lineView)
//            lineView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
//            lineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 38).isActive = true
//            lineView.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 38).isActive = true
            headerLabel.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 100).isActive = true
        }
        
        return containerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func fetchEvents(completion: @escaping ([Event]) -> Void) {
        guard let currentUser = currentUser else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
        
        EventController.shared.fetchEvents(forUserUid: currentUser.uid, withType: .task) { (events) in
            if !events.isEmpty {
                completion(events)
            } else {
                completion([])
            }
        }
    }
}
