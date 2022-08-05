//
//  DateHelper.swift
//  social_network_app
//
//  Created by admin on 7/23/22.
//

import Foundation

class DateHelper {
    
    static func dateToDouble(date: Date) -> Double {
        let timeInterval = date.timeIntervalSince1970
        let double = Double(timeInterval)
        
        return double
    }
    
    static func doubleToDate(double: Double) -> Date {
        let timeInterval = TimeInterval(double)
        let myDate = Date(timeIntervalSince1970: timeInterval)
        
        return myDate
    }
    
    static func getHourMinute(date: Date) -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        let str = "\(hour) : \(minute)"
        return str
    }
    
    
}
