//
//  Exam+CoreDataClass.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 28/05/2021.
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
    
    public var peaksArray: [Peaks] {
        let set = peaks as? Set<Peaks> ?? []
        
        return set.sorted {
            $0.peakNo < $1.peakNo
        }
    }

    public var resultName: ExamResult {
        
        if self.heartRate > 60 && self.heartRate <= 100 {
            
            return .good
            
        } else if self.heartRate <= 60 && self.heartRate > 50 || self.heartRate <= 110 && self.heartRate > 100 {
            
            return .alerting
            
        } else if self.heartRate > 100 && self.heartRate <= 180 && self.type == "resting" || self.heartRate <= 50 && self.heartRate > 45 {
            
            return .bad
            
        } else {
        
            return .critical
        
        }
    }
}

