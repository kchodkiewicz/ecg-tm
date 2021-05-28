//
//  Sample+CoreDataProperties.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 28/05/2021.
//
//

import Foundation
import CoreData


extension Sample {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sample> {
        return NSFetchRequest<Sample>(entityName: "Sample")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var xValue: Double
    @NSManaged public var yValue: Double
    @NSManaged public var origin: Exam?

}

extension Sample : Identifiable {

}
