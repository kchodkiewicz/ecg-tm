//
//  Sample+CoreDataProperties.swift
//  
//
//  Created by Krzysztof Chodkiewicz on 26/04/2021.
//
//

import Foundation
import CoreData


extension Sample {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sample> {
        return NSFetchRequest<Sample>(entityName: "Sample")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var xValue: Int64
    @NSManaged public var yValue: Int64
    @NSManaged public var origin: Exam?


}
