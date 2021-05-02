//
//  Exam+CoreDataClass.swift
//  
//
//  Created by Krzysztof Chodkiewicz on 26/04/2021.
//
//

import Foundation
import CoreData

@objc(Exam)
public class Exam: NSManagedObject, Identifiable {

    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedDate: Date {
        date ?? Date()
    }
    
    public var wrappedNotes: String {
        notes ?? ""
    }
    
    public var wrappedType: String {
        type ?? "resting"
    }
    
    public var sampleArray: [Sample] {
        let set = sample as? Set<Sample> ?? []
        
        return set.sorted {
            $0.xValue < $1.xValue
        }
    }
    
}
