//
//  CalendarHelper.swift
//  Roommater
//
//  Created by Drew on 1/31/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import Foundation

class CalendarHelper{
    
    static var daysThisMonth: Double {
        let range = Calendar.current.range(of: .day, in: .month, for: Date())!
        return Double(range.count)
    }
    
}
