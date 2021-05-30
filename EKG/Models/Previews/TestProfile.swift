//
//  TestProfile.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 29/05/2021.
//

import Foundation
import CoreData

class TestProfile: TestData {
    
    init(context: NSManagedObjectContext) {
        super.init(context: context, entityName: "Profile")
    }
    
    override func addRows() throws {
        if super.noRowsExist() {
            var samples: [Sample] = []
            
            for index in 0...1000 {
                let sample = Sample(context: context)
                sample.id = UUID()
                sample.xValue = Double(index)
                sample.yValue = Double.random(in: -0.6...0.6)
                samples.append(sample)
            }
            
            let peaks = [0.0, 0.3, 0.5, 0.7, 1.1, 1.2, 1.4, 1.6, 1.3, 1.6]
            
            let exam = Exam(context: context)
            exam.id = UUID()
            exam.date = Date()
            exam.heartRate = 69
            exam.addToPeaks(NSSet(array: peaks))
            exam.addToSample(NSSet(array: samples))
            
            let exam2 = Exam(context: context)
            exam2.id = UUID()
            exam2.date = Date(timeInterval: 1, since: Date())
            exam2.heartRate = 110
            exam2.addToPeaks(NSSet(array: peaks))
            exam2.addToSample(NSSet(array: samples))
            
            let profile = Profile(context: context)
            profile.addToExam(exam)
            profile.addToExam(exam2)
            
            try! self.context.save()
        }
    }
    
    override func getRows() throws -> [Any]? {
        return try super.getRows()
    }
    
    func getRows(count: Int) throws -> [Profile] {
        return try super.getRows(count: count)
    }
}

