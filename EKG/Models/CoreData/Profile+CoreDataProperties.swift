//
//  Profile+CoreDataProperties.swift
//  
//
//  Created by Krzysztof Chodkiewicz on 27/04/2021.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var age: Date?
    @NSManaged public var examDuration: Float
    @NSManaged public var firstName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lastName: String?
    @NSManaged public var username: String?
    @NSManaged public var profileColor: String?
    @NSManaged public var exam: NSSet?
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedColor: String {
        profileColor ?? "crimson"
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
    
    public var wrappedAge: Date {
        age ?? Date()
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