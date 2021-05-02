//
//  Exam+CoreDataProperties.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 03/05/2021.
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
    @NSManaged public var notes: String?
    @NSManaged public var type: String?
    @NSManaged public var origin: Profile?
    @NSManaged public var sample: NSSet?

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

