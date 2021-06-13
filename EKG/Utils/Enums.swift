//
//  Enums.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 26/04/2021.
//

import Foundation

//MARK: - ProfileColors
enum ProfileColor: String, CaseIterable {
    
    case blackGrape = "blackGrape"
    case coolGray = "coolGray"
    case vividYellow = "vividYellow"
    case dodgerBlue = "dodgerBlue"
    case iris = "iris"
    case persianBlue = "presianBlue"
    case trypanBlue = "trypanBlue"
    case ultramarine = "ultramarine"
    case violet = "violet"
    case vividSkyBlue = "vividSkyBlue"
    case crimson = "crimson"
    case aquamarine = "aquamarine"
    
    var ColorValue: Int64 {
        
        get {
            
            switch self {
            case .crimson: return 0
            case .violet: return 1
            case .coolGray: return 2
            case .iris: return 3
            case .blackGrape: return 4
            case .trypanBlue: return 5
            case .persianBlue: return 6
            case .ultramarine: return 7
            case .dodgerBlue: return 8
            case .vividSkyBlue: return 9
            case .vividYellow: return 10
            case .aquamarine: return 11
                
            }
        }
    }
    
    static public func ColorName(value: String) -> ProfileColor {
        
        switch value {
        case "crimson": return .crimson
        case "violet": return .violet
        case "coolGray": return .coolGray
        case "iris": return .iris
        case "blackGrape": return .blackGrape
        case "trypanBlue": return .trypanBlue
        case "presianBlue": return .persianBlue
        case "ultramarine": return .ultramarine
        case "dodgerBlue": return .dodgerBlue
        case "vividSkyBlue": return .vividSkyBlue
        case "vividYellow": return .vividYellow
        case "aquamarine": return .aquamarine
        default:
            return .crimson
        }
        
    }
    
    
}

extension ProfileColor: Identifiable {
    var id: ProfileColor { self }
}

//MARK: - Tabs Tags
enum Tab: Int, CaseIterable {
    case overview = 0
    case history = 1
    case exam = 2
    case profile = 3
}

//MARK: - Exam Type
enum ExamType: String, CaseIterable {
    case resting = "resting"
    case stress = "stress"
    //case ambulatory = "ambulatory"
}

//MARK: - Exam Result
public enum ExamResult: String, CaseIterable {
    case good = "good"
    case alerting = "alerting"
    case bad = "bad"
    case critical = "critical"
    
    func next() -> ExamResult {
        switch (self) {
            case .good: return .alerting
            case .alerting: return .bad
            case .bad: return .critical
            case .critical: return .critical
        }
    }
}

public enum TimePeriod: Int, CaseIterable {
    case week = 7
    case month = 30
    case year = 365
    
    var displayName: String {
        
        get {
            
            switch self {
            case .week: return "week"
            case .month: return "month"
            case .year: return "year"
                
            }
        }
    }
    
}
