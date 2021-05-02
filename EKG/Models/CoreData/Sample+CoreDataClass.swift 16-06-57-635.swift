//
//  Sample+CoreDataClass.swift
//  
//
//  Created by Krzysztof Chodkiewicz on 26/04/2021.
//
//

import Foundation
import CoreData

@objc(Sample)
public class Sample: NSManagedObject {
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
}
