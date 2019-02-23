//
//  EventInterval.swift
//  Roommater
//
//  Created by Drew on 1/31/19.
//  Copyright © 2019 Dre. All rights reserved.
//

import Foundation

enum EventInterval: String {
    case every = "Every"
    case everyOther = "Every Other"
    case everyThird = "Every Third"
    
    var multiplier: Int{
        switch self {
        case .every:
            return 1
        case .everyOther:
            return 2
        case .everyThird:
            return 3
        }
    }
}
