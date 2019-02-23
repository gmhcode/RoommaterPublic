//
//  NonAdminHomeRulesViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/23/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class NonAdminHomeRulesViewController: UIViewController {

    @IBOutlet weak var houseRulesLabel: UILabel!
    
    var place = PlaceController.shared.currentPlace
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setUpViews()
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func setUpViews(){
        houseRulesLabel.text = place?.homeRules
        houseRulesLabel.addGrayUnderline()
        
    }
    
    func setUpNavigationBar(){
        self.navigationItem.title = "House Rules"
        self.navigationItem.largeTitleDisplayMode = .always
       
    }
    
   
}

