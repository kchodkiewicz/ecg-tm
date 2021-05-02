//
//  Profile+CoreDataClass.swift
//  
//
//  Created by Krzysztof Chodkiewicz on 27/04/2021.
//
//

import Foundation
import CoreData

@objc(Profile)
public class Profile: NSManagedObject, Identifiable {
    
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
