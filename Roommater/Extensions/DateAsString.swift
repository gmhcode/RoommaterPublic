//
//  DateAsString.swift
//  Roommater
//
//  Created by Greg Hughes on 1/21/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import Foundation
extension Date{
    
    var asString: String{
        let formatter = DateFormatter()
        
        formatter.dateStyle = .full
        return formatter.string(from: self)
    }
    
    var asTimeString: String{
    let formatter = DateFormatter()
    formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
}
