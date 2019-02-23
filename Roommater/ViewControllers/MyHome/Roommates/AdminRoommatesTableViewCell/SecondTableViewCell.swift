//
//  SecondTableViewCell.swift
//  Roommater
//
//  Created by Greg Hughes on 1/24/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

protocol AdminTableViewCellDelegate: class {
    func removeTenantButton(for cell: SecondTableViewCell)
    
}

class SecondTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var removeTenantButton: UIButton!
    
    
    @IBOutlet weak var roommateImage: UIImageView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var place : Place?
    
    weak var delegate : AdminTableViewCellDelegate?
    
    var buttonIsChecked : Bool = false
    
    var user : InternalUser? {
        
        didSet{
        
            guard let _ = place,
                let user = user else { return }
            
            if user.admin == true{
                buttonIsChecked = true
            }
            updateViews()
        }
    }
    
    
    
    func updateViews(){
        
        phoneNumberLabel.text = user?.phoneNumber
        nameLabel.text = user?.fullname
        roommateImage.image = user?.profileImage
        
        roommateImage.layer.cornerRadius = roommateImage.frame.size.width / 2

        
        
    }
    
    
    @IBAction func removeTenantButtonTapped(_ sender: Any) {
       guard let place = place,
            let user = user else { return }
        
        delegate?.removeTenantButton(for: self)
        
    }
    
    @IBAction func adminButtonTapped(_ sender: Any) {
        updateViews()
        buttonIsChecked.toggle()
    
    }
    
        
    
    
    
}
