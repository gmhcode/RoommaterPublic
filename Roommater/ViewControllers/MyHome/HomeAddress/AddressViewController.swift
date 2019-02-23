//
//  AddressViewController.swift
//  Roommater
//
//  Created by Greg Hughes on 1/31/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class AddressViewController: UIViewController {

    @IBOutlet weak var addressTextView: UITextView!
    
    
    var place = PlaceController.shared.currentPlace
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        addressTextView.text = place?.homeAddress
        addressTextView.addGrayUnderline()
        
        // Do any additional setup after loading the view.
    }
    
    func setUpViews(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNewAddress))
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Home Address"
    }
    
    
    @objc func saveNewAddress(){
        
        guard let place = place else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

        PlaceController.shared.updatePlaceAddress(toPlace: place, toAdress: addressTextView.text) { (place) in
            
            PlaceController.shared.currentPlace = place
            self.navigationController?.popViewController(animated: true)
        }
    }
}
