//
//  Peaks+CoreDataClass.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 28/05/2021.
//
//

import Foundation
import CoreData

@objc(Peaks)
public class Peaks: NSManagedObject, Comparable {
    
    public static func < (lhs: Peaks, rhs: Peaks) -> Bool {
        lhs.xValue < rhs.xValue
    }
    
    public static func <= (lhs: Peaks, rhs: Peaks) -> Bool {
        lhs.xValue <= rhs.xValue
    }
    
    public static func > (lhs: Peaks, rhs: Peaks) -> Bool {
        lhs.xValue > rhs.xValue
    }
    
    public static func >= (lhs: Peaks, rhs: Peaks) -> Bool {
        lhs.xValue >= rhs.xValue
    }
    
    public static func - (lhs: Peaks, rhs: Peaks) -> Double {
        lhs.xValue - rhs.xValue
    }
    
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
}
