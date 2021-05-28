//
//  Sample+CoreDataClass.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 28/05/2021.
//
//

import Foundation
import CoreData

@objc(Sample)
public class Sample: NSManagedObject, Comparable {
    
    public static func < (lhs: Sample, rhs: Sample) -> Bool {
        lhs.yValue < rhs.yValue
    }
    
    public static func <= (lhs: Sample, rhs: Sample) -> Bool {
        lhs.yValue <= rhs.yValue
    }
    
    public static func > (lhs: Sample, rhs: Sample) -> Bool {
        lhs.yValue > rhs.yValue
    }
    
    public static func >= (lhs: Sample, rhs: Sample) -> Bool {
        lhs.yValue >= rhs.yValue
    }
    
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
}
