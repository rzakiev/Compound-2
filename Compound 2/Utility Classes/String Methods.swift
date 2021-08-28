//
//  String Methods.swift
//  Compound 2
//
//  Created by Robert Zakiev on 19.10.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation

extension String {
    ///Converts `235%` into `x2.3`
    static func beautifulGrossGrowthRateString(from growthRate: Int) -> String {
        switch growthRate {
        case 0:
            return ""
        case 1...99:
            return String("+ \(growthRate)%")
        case 100...:
            return "x" + String(format: "%.0f", Double(growthRate)/100.0 + 1)
        case -100..<0:
            return String(" \(growthRate)%")
        default:
            return String("\(growthRate)")
        }
    }
}

//MARK: - Date methods
extension String {
    func asDate(format: Date.Format = .ddMMyyyy) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: self)
    }
}
