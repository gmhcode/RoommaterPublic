//
//  Extensions.swift
//  Roommater
//
//  Created by Frank Martin Jr on 1/30/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addUnderline() {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        self.superview!.addSubview(line)
        
        line.backgroundColor = .black
        NSLayoutConstraint(item: line, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -4).isActive = true
        NSLayoutConstraint(item: line, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: line, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 1).isActive = true
    }
    
    func addGrayUnderline() {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        self.superview!.addSubview(line)
        
        line.backgroundColor = UIColor(red: 211, green: 211, blue: 211)
        NSLayoutConstraint(item: line, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -4).isActive = true
        NSLayoutConstraint(item: line, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: line, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 1).isActive = true
    }
}



