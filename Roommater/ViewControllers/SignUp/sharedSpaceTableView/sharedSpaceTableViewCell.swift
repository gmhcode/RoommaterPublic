//
//  sharedSpaceTableViewCell.swift
//  Roommater
//
//  Created by Greg Hughes on 1/23/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import UIKit

protocol SharedSpaceTableViewCellDelegate: class {
    func addSpace(cell: SharedSpaceTableViewCell, space: String)
}

class SharedSpaceTableViewCell: UITableViewCell {
    @IBOutlet weak var spaceTextField: UITextField!
    @IBOutlet weak var spaceNameLabel: UILabel!
    
    var place : Place?
    
    
    var space: String? {
        didSet {
            updateViews()
        }
    }
    weak var delegate: SharedSpaceTableViewCellDelegate?
    @IBOutlet weak var sharedSpaceTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func updateViews() {
        sharedSpaceTextField.text = space
    }
    @IBAction func addSpaceButtonTapped(_ sender: Any) {
        guard let space = sharedSpaceTextField.text,
            !space.isEmpty, let place = place
            else { return }
        
        PlaceController.shared.updateAddSpaces(toPlace: place, space: space) { (place) in
            self.place = place
        }
        
        addButton.isHidden.toggle()
        addButton.isHidden = true
        delegate?.addSpace(cell: self, space: space)
    }
}
