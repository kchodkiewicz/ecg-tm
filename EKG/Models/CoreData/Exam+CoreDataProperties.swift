//
//  Exam+CoreDataProperties.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 28/05/2021.
//
//

import Foundation
import CoreData


extension Exam {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exam> {
        return NSFetchRequest<Exam>(entityName: "Exam")
    }

    @NSManaged public var date: Date?
    @NSManaged public var heartRate: Int64
    @NSManaged public var id: UUID?
    @NSManaged public var notes: String?
    @NSManaged public var timeBetweenPeaks: Double
    @NSManaged public var type: String?
    @NSManaged public var origin: Profile?
    @NSManaged public var peaks: NSSet?
    @NSManaged public var sample: NSSet?

}

// MARK: Generated accessors for peaks
extension Exam {

    @objc(addPeaksObject:)
    @NSManaged public func addToPeaks(_ value: Peaks)

    @objc(removePeaksObject:)
    @NSManaged public func removeFromPeaks(_ value: Peaks)

    @objc(addPeaks:)
    @NSManaged public func addToPeaks(_ values: NSSet)

    @objc(removePeaks:)
    @NSManaged public func removeFromPeaks(_ values: NSSet)

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
