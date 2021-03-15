//
//  Profile+CoreDataProperties.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 12/03/2021.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var age: Int64
    @NSManaged public var examDuration: Float
    @NSManaged public var firstName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lastName: String?
    @NSManaged public var username: String?
    @NSManaged public var exam: NSSet?
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedFirstName: String {
        firstName ?? "Unknown"
    }
    
    public var wrappedLastName: String {
        lastName ?? "Unknown"
    }
    
    public var wrappedUsername: String {
        username ?? "-"
    }
    
    public var examArray: [Exam] {
        let set = exam as? Set<Exam> ?? []
        
        return set.sorted {
            $0.wrappedDate > $1.wrappedDate
        }
    }
}

// MARK: Generated accessors for exam
extension Profile {

    @objc(addExamObject:)
    @NSManaged public func addToExam(_ value: Exam)

    @objc(removeExamObject:)
    @NSManaged public func removeFromExam(_ value: Exam)

    @objc(addExam:)
    @NSManaged public func addToExam(_ values: NSSet)

    @objc(removeExam:)
    @NSManaged public func removeFromExam(_ values: NSSet)

}

extension Profile : Identifiable {

}
