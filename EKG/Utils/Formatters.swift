//
//  Formatters.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 26/04/2021.
//

import Foundation

struct Formatters {

    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    static let justDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    static func withoutYear(date: Date) -> String {
       
        let current = Calendar.current
        let shortDate = current.dateComponents([.day, .month], from: date)
        
        let stringDay = shortDate.day! < 10 ? "0" + String(shortDate.day!) : String(shortDate.day!)
        let stringMonth = shortDate.month! < 10 ? "0" + String(shortDate.month!) : String(shortDate.month!)
        return stringDay + "." + stringMonth
    }
    
    static let titleDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    static let birthDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.minimum = 0
        return formatter
    }()
    
    static public var closeBirthDateRange: ClosedRange<Date> {
        let lower = Calendar.current.date(byAdding: .year, value: -150, to: Date())!
        let upper = Date()
        
        return lower...upper
    }
    
    
}
