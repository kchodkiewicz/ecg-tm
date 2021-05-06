//
//  ActiveSession.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 13/03/2021.
//
import Combine
import Foundation

class ActiveSession: ObservableObject { 
    @Published var id: UUID?
}
