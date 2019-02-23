//
//  GetStartedViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/22/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class GetStartedViewController: UIViewController {

    var user = InternalUserController.shared.loggedInUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

  
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        i
        if segue.identifier == "joinHomeSegue"{
            guard let user = user else {return}
            let destistinationVC = segue.destination as! JoinAHomeViewController
            destistinationVC.currentUser = user
        }
        if segue.identifier == "makeHomeSegue"{
            guard let user = user else {return}
            let destistinationVC = segue.destination as! MakeAHomeViewController
            destistinationVC.currentUser = user
        }
    }
}
