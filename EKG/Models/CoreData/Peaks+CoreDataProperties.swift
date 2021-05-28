//
//  Peaks+CoreDataProperties.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 28/05/2021.
//
//

import Foundation
import CoreData


extension Peaks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Peaks> {
        return NSFetchRequest<Peaks>(entityName: "Peaks")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var peakNo: Double
    @NSManaged public var xValue: Double
    @NSManaged public var origin: Exam?

}

extension Peaks : Identifiable {

}
