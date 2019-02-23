//
//  AdminHomeRulesViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/23/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class AdminHomeRulesViewController: UIViewController {

    var place = PlaceController.shared.currentPlace
    
    
    @IBOutlet weak var homeRulesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setUpViews()
        self.title = "House Rules"
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
        homeRulesTextView.text = place?.homeRules
        homeRulesTextView.addGrayUnderline()
        
    }
    
    func setUpNavigationBar(){
        self.navigationItem.title = "House Rules"
        self.navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped)  )
    }
    
    
    @objc func saveButtonTapped(){
        guard let textView = homeRulesTextView.text,
            let place = place else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

        PlaceController.shared.updateHomeRules(toPlace: place, homeRules: textView) { (place) in
            PlaceController.shared.currentPlace = place
            self.navigationController?.popViewController(animated: true)
        }
    }
}
