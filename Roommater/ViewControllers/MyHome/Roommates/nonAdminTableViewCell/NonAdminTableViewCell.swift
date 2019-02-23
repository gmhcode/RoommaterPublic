//
//  NonAdminTableViewCell.swift
//  Roommater
//
//  Created by Greg Hughes on 2/1/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

class NonAdminTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var underlineLine: UIView!
    
    
    
    
    var user : InternalUser?{
        didSet{
            updateViews()
        }
    }
    var place : Place?
    
    
    func updateViews(){
        
        nameLabel.text = user?.fullname
        phoneNumberLabel.text = user?.phoneNumber
        underlineLine.addGrayUnderline()
        profilePicture.image = user?.profileImage
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        
    }
}
