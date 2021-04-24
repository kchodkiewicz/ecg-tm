//
//  ProfileTmp.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 29/03/2021.
//

import Foundation

struct ProfileTmp {
    var username: String
    var firstName: String
    var lastName: String
    var age: Int64
    var examDuration: Float
    
    static let `default` = Self(username: "username", firstName: "firstName", lastName: "lastName", age: 1, examDuration: 5)
    
    init(username: String, firstName: String, lastName: String, age: Int64, examDuration: Float) {
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.examDuration = examDuration
    }
}