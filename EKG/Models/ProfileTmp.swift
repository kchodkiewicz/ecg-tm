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
    var age: String
    var examDuration: Float
    
    static let `default` = Self(username: "username", firstName: "firstName", lastName: "lastName", age: "", examDuration: 5)
    
    init(username: String, firstName: String, lastName: String, age: String, examDuration: Float) {
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.examDuration = examDuration
    }
}
