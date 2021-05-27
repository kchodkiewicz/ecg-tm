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
    
    public var heartRate: Int {
        // peak if value greater than both neighbours and value
        // grater than 512 (or other constant according to samples)
        let samples = self.sampleArray
        var peaks: [Double] = []
        
        guard samples.count - 1 > 1 else {
            return -1
        }
        for index in 1 ..< samples.count - 1 {
            if (samples[index] > samples[index + 1] && samples[index] > samples[index - 1]) && samples[index].yValue >= 0.6 {
                peaks.append(samples[index].xValue)
            }
        }
        
        let duration = samples.count / 250
        guard duration != 0 else {
            return -1
        }
        let rate = Int(Double(peaks.count) / Double(duration) * 60.0) // for bpm
        
        return rate
        
    }
    
    public var resultName: ExamResult {
        //TODO: make proper cirteria
        if heartRate > 100 || heartRate < 50 {
            return .critical
        } else {
            return .good
        }
    }
    
}
