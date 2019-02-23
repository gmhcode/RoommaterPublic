//
//  CalendarViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/20/19.
//  Copyright © 2019 Dre. All rights reserved.
//

    

import UIKit
import JTAppleCalendar
class CalendarViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var dateRange : [Date]?
    var events : [Event] = []
    var dateEvents : [[Event]] = []
    var ddates : [TimeInterval]?

    var dateEventObjects = [Date : [Event]]()
    
    var eventsFromServer: [Date:[Event]] = [:] {
        didSet {
//            tableView.reloadData()
        }
    }
    
    var dateSections: [Date] {
        var dateSections: [Date] = []
        for (date, _) in eventsFromServer.sorted(by: {$0.key < $1.key})
        {
            if !dateSections.contains(date) {
                dateSections.append(date)
            }
        }
        return dateSections
    }
    
    var datesWithEvents: [String] = []
    let todayDate = Date()
    
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendarTVCNib = UINib(nibName: "CalendarEventCell", bundle: nil)
        tableView.register(calendarTVCNib, forCellReuseIdentifier: "dayEventCell")
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.getServerEvents(completion: { (serverObjects) in
            guard let serverObjects = serverObjects else { return }
            self.eventsFromServer = serverObjects
            DispatchQueue.main.async {
                self.calendarView.reloadData()
            }
        })
        
        func updateViews(){
            
        }
        
        
        self.navigationController?.isNavigationBarHidden = false
        tableView.delegate = self
        tableView.dataSource = self
   
        self.calendarView.scrollToDate(Date(), animateScroll: false)
        //open with todays date
        self.calendarView.selectDates([Date()])

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.calendarView.reloadData()
    }

    //loads current date on viewDidLoad
    func setupCalendarView(completion: @escaping (Bool) -> Void){
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // MARK: - makes the spacing between days 0

    }
    
    func getServerEvents(completion: @escaping ([Date:[Event]]?) -> Void) {
        guard let dateRange = dateRange,
        let first = dateRange.first,
        let last = dateRange.last
            else {completion(nil); print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        var serverEvents = [Date: [Event]]()
       
        
        EventController.shared.fetchEvents(withDateRangeStartingAt: first.timeIntervalSince1970, ending: last.timeIntervalSince1970) { (fetchedEvents) in
            if !fetchedEvents.isEmpty {
                EventController.shared.events = fetchedEvents
                
                var events: [Date: [Event]] = [:]
//                let myGroup = DispatchGroup()
                
                for event in fetchedEvents {
                    let eventDate = Date(timeIntervalSince1970: TimeInterval(Int(event.date)))
                    if events.keys.contains(eventDate) {
                        events[eventDate]?.append(event)
                    } else {
                        events[eventDate] = [event]
                    }
                }

                serverEvents = events
                self.dateEventObjects = events
                self.view.setNeedsLayout()
                
                completion(serverEvents)
            }
        }
    }
    
    // MARK: - Calendar vv handles colors for all textb
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState){
        
        guard let validCell = view as? CalendarCell else { return }
        
        if cellState.isSelected{
            validCell.dateLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            //sets color of text for selected days
        } else {
            if cellState.dateBelongsTo == .thisMonth{
                //set color for cells of this month
                validCell.dateLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }else {
                validCell.dateLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                //sets colors outside this month but still in view
            }
        }
        
    }
    // MARK: - Calendar vv toggles the color change in selected cells
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else { return }
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
        
    }
//    897FCCE
    func setUpViewsOfCalendar(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        
//        self.formatter.dateFormat = "yyyy"
//        self.year.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM yyyy"
//        self.month.text = self.formatter.string(from: date)
        
        self.navigationItem.title = self.formatter.string(from: date)
        navigationController?.navigationBar.barTintColor = UIColor.white
        //SETS THE MONTH TEXT WHEN SWIPED
    }
    
    func cellDotsAppear(cell: JTAppleCell?, cellState: CellState){
        
        guard let cell = cell as? CalendarCell else { return }
        
        formatter.dateFormat = "yyyy MM dd"
        
        handleCellEvents(cell: cell, cellState: cellState)
        
    }
    
    // MARK: - Calander Dot activates if we get info from server
    func handleCellEvents(cell: CalendarCell?, cellState: CellState){
        cell?.dot.isHidden = !eventsFromServer.contains(where: { (key, value) -> Bool in
            
            let keyDate = Date(timeIntervalSince1970: key.timeIntervalSince1970)
            let keyDateComponent = Calendar.current.dateComponents([.day, .month, .year], from: keyDate)
            
            let cellStateDate = Date(timeIntervalSince1970: cellState.date.timeIntervalSince1970)
            let cellStateComponent = Calendar.current.dateComponents([.day, .month, .year], from: cellStateDate)
            return keyDateComponent == cellStateComponent
        })
        
        if cell?.dot.isHidden == false{
            print("🔥\(cellState.date.asString)")
            
            //extract all datesWithEvents if dot is hidden
            datesWithEvents.append(cellState.date.asString)

            tableView.reloadData()
            tableView.setNeedsLayout()
            self.view.setNeedsLayout()
        }
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate{
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CalendarCell
        
        cell.dateLabel.text = cellState.text
        
        handleCellTextColor(view: cell, cellState: cellState)
        // MARK: - Calendar resets cells when moving between months
        handleCellSelected(view:  cell, cellState: cellState)
        cellDotsAppear(cell: cell, cellState: cellState)
        
        return cell
    }
    
    // MARK: - Calendar color change when selecting and de-selecting
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        
        //play with dates here, configure
        print(date.asString)
        print(date)
        
        handleCellSelected(view:  cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        cellDotsAppear(cell: cell, cellState: cellState)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view:  cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        cellDotsAppear(cell: cell, cellState: cellState)
    }
    
    //VV swipe action
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpViewsOfCalendar(from: visibleDates)
        
        
        let dateArray = printVisibleDates(visibleDatesMonthDates: visibleDates.monthDates)
        dateRange = dateArray
        print(" ❇️ \(String(describing: dateRange)) ")
        self.getServerEvents(completion: { (serverObjects) in
            DispatchQueue.main.async {
                guard let serverObjects = serverObjects else { print(">>>\(#file) \(#line): guard let failed <<<"); return }
                self.eventsFromServer = serverObjects
                self.calendarView.reloadData()
            }
        })
    }
    
    //use this to extract all the dates from the month
    func printVisibleDates(visibleDatesMonthDates: [(Date,IndexPath)]) -> [Date]{
        
        var i = 0
        var dateArray : [Date] = []
        
    
        while i < visibleDatesMonthDates.count{
            dateArray.append(visibleDatesMonthDates[i].0)
            i += 1
        }
        return dateArray
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier
        guard let destinationVC = segue.destination as? EventTableViewController,
            let indexPath = tableView.indexPathForSelectedRow
            else { return }
        
        let dateSection = dateSections[indexPath.section]
        guard let events = eventsFromServer[dateSection] else { return }
        let event = events[indexPath.row]
        destinationVC.event = event
        destinationVC.eventDate = dateSection

    }    
}

extension CalendarViewController: JTAppleCalendarViewDataSource{
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CalendarCell
        
        cell.dateLabel.text = cellState.text
    }
    
    // MARK: - Configuring Dates
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        formatter.date(from: "2017 01 01")
        
        let startDate = formatter.date(from: "2017 01 01")
        let endDate = formatter.date(from: "2200 12 31")
        
        guard let sDate = startDate, let eDate = endDate else { return ConfigurationParameters(startDate: Date(), endDate: Date()) }
        // MARK: - showing buggy Date
        
        let parameters = ConfigurationParameters(startDate: sDate, endDate: eDate, numberOfRows: 5, calendar: Calendar.current, generateInDates: .forAllMonths, generateOutDates: .tillEndOfRow, firstDayOfWeek: .monday)
        return parameters
        
    }
}

extension UIColor{
    convenience init(colorWithHexValue value: Int, alpha: CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x000FF) / 255.0,
            alpha: alpha
            // MARK: - Calendar allows us to use hex values...?
        )
    }
}

