//
//  Exam+CoreDataProperties.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 12/03/2021.
//
//

import Foundation
import CoreData


extension Exam {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exam> {
        return NSFetchRequest<Exam>(entityName: "Exam")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var origin: Profile?
    @NSManaged public var sample: NSSet?
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedDate: Date {
        date ?? Date()
    }
    
    public var sampleArray: [Sample] {
        let set = sample as? Set<Sample> ?? []
        
        return set.sorted {
            $0.xValue < $1.xValue
        }
    }

}

// MARK: Generated accessors for sample
extension Exam {

    @objc(addSampleObject:)
    @NSManaged public func addToSample(_ value: Sample)

    @objc(removeSampleObject:)
    @NSManaged public func removeFromSample(_ value: Sample)

    @objc(addSample:)
    @NSManaged public func addToSample(_ values: NSSet)

    @objc(removeSample:)
    @NSManaged public func removeFromSample(_ values: NSSet)

}

extension Exam : Identifiable {

}
