//
//  Date Methods.swift
//  Compound 2
//
//  Created by Robert Zakiev on 06.01.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation


//We should probably use MM/dd/yyyy as the default date format

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
        [1, 7].contains(currentDayOfTheWeek) //[1, 7] is Saturday + Sunday
    }
    
    static var todayIsNotWeekend: Bool { !todayIsWeekend() }
    
    static func getFormattedDate(format: String = "dd.MM.yy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: Date())
    }
    
    
    static func convertStringToDate(date: String, format: String = "yy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: date)
    }
    
    static func yearFromDate(_ date: Date) -> Int? {
        Calendar.current.dateComponents([.year], from: date).year
    }
}

extension Date {
    func asString(format: String = "MM/dd/yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    ///Returns the current date in a human readable format (e.g. `14 мая`)
    static func beautifulCurrentDate() -> String {
        let formattedDate = Date().asString()
        let splitDate = formattedDate.split(separator: "/")
        guard splitDate.count >= 3 else {
            Logger.log(error: "The split date does not have the required 3 constituents: \(formattedDate)")
            return formattedDate
        }
        
        let month: String
        switch splitDate[0] {
        case "01": month = "Января"
        case "02": month = "Февраля"
        case "03": month = "Марта"
        case "04": month = "Апреля"
        case "05": month = "Мая"
        case "06": month = "Июня"
        case "07": month = "Июля"
        case "08": month = "Августа"
        case "09": month = "Сентября"
        case "10": month = "Октября"
        case "11": month = "Ноября"
        case "12": month = "Декабря"
        default:
            month = ""
        }
        
        return splitDate[1] + " " + month
    }
}

//MARK: - Timestamp Methods
extension Date {
    ///Converts a date into a UNIX timestamp. The returned value is of type Double.
    static func convertToTimestamps(_ date: String, format: String = "MM/dd/yyyy") -> Double? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        guard let date = dateFormatter.date(from: date) else {
            Logger.log(error: "Unable to instantiate a date from the string: \(date)")
            return nil
        }
        
        return date.timeIntervalSince1970
    }
    
    ///Converts a UNIX timestamp into a date.
    static func convertTimestampsToDate(_ timestamp: Double) -> Date {
        return Date(timeIntervalSince1970: timestamp)
    }
}

struct DateFormats {
    static let ddMMyyy = "dd/MM/yyyy"
}
