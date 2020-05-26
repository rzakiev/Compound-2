//
//  Date Methods.swift
//  Compound 2
//
//  Created by Robert Zakiev on 06.01.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

extension Date {
    static var lastYear: Int {
        let components = Calendar.current.dateComponents([.year], from: Date())
        return components.year! - 1
    }
    
    static var currentYear: Int {
        return lastYear + 1
    }
    
    static var currentDayOfTheWeek: Int { Calendar.current.dateComponents([.weekday], from: Date()).weekday! }
    
    static func todayIsWeekend() -> Bool {
        return [1, 7].contains(currentDayOfTheWeek)
    }
    
    static func getFormattedDate(format: String = "dd.MM.yy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: Date())
    }
}
