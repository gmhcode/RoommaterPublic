//
//  SharedSpaceViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/28/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class SharedSpaceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
var place = PlaceController.shared.currentPlace
var spaces =  PlaceController.shared.currentPlace?.spaces
//    var spaces : [String] = ["hello","there"]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var spaceTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return spaces?.count ?? 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = spaces?[indexPath.row]
        
        return cell
    }
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func addSpaceButtonTapped(_ sender: Any) {
        guard spaceTextField.text != "",
            let spaceText = spaceTextField.text,
            let place = place else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        spaces?.append(spaceText)
        
        PlaceController.shared.updateAddSpaces(toPlace: place, space: spaceText) { (place) in
            guard let place = place else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            PlaceController.shared.currentPlace = place
            
            self.spaces = place.spaces
            
            print(PlaceController.shared.currentPlace?.spaces?.count)
//            self.addRow()
            self.tableView.reloadData()
            
            self.spaceTextField.text = ""
            
        }
    }
    
    
    
    func addRow(){
        
        guard let spaces = spaces else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        spaceTextField.text = ""
        view.endEditing(true)
        
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func tapOutSideButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
//self.addRow()
//guard spaceTextField.text != "",
//    let spaceText = spaceTextField.text,
//    let place = place else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
//
////        spaces.append(spaceTextField.text ?? "")
//PlaceController.shared.updateAddSpaces(toPlace: place, space: spaceText) { (place) in
//
//    PlaceController.shared.currentPlace = place
//
//
//    self.tableView.reloadData()
//}
