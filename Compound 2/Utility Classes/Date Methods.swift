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
    
    static func yearFromDate(_ date: Date) -> Int? {
        Calendar.current.dateComponents([.year], from: date).year
    }
}

extension Date {
    func asString(format: Date.Format = .ddMMyyyy) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
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
    ///Converts a date into a UNIX timestamp
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

//MARK: - Date Comparison
extension Date {
    ///Compares two dates and returns the difference in a neat tuple containing optional `month`, `day`, `hour`, `minute`, and `second`components
    static func - (recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second
        
        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
    
    ///Determines if a certain number of seconds/hours/days/etc. has elapsed since the specified date
    static func more(than number: Int, _ component: Calendar.Component, elapsedSince date: Date) -> Bool? {
        
        let interval = Date() - date
        
        switch component {
        case .second:
            if interval.second != nil && interval.second! == 0 { return false }
            if interval.second != nil && interval.second! > number { return true }
            return false
        case .minute:
            if interval.minute != nil && interval.minute! == 0 { return false }
            if interval.minute != nil && interval.minute! > number { return true }
            return false
            
        case .hour:
            if interval.hour != nil && interval.hour! == 0 { return false }
            if interval.hour != nil && interval.hour! > number { return true }
            return false
        case .day:
            if interval.day != nil && interval.day! == 0 { return false }
            if interval.day != nil && interval.day! > number { return true }
            return false
            
        default:
            return nil
        }
    }
}

extension Date {
    enum Format: String {
        ///The usual format in the USA. Use it when working with American APIs
        case MMddyyy = "MM/dd/yyyy"
        ///Regular russian date style
        case ddMMyyyy = "dd/MM/yyyy"
    }
}
