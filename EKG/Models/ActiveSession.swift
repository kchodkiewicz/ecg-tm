//
//  ActiveSession.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 13/03/2021.
//

import Foundation

class ActiveSession: ObservableObject {
    @Published var username: String = ""
    @Published var id: UUID?
    @Published var profile: Profile?
    
}
