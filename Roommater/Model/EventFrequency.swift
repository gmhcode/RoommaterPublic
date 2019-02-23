//
//  EventFrequency.swift
//  Roommater
//
//  Created by Drew on 1/31/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import Foundation

enum EventFrequency: String {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    
    var timeIntervalToNext: TimeInterval{
        switch self {
        case .day:
            return 60 * 60 * 24
        case .week:
            return 60 * 60 * 24 * 7
        case .month:
            return 60 * 60 * 24 * CalendarHelper.daysThisMonth
        }
    }
}
