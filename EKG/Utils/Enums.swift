//
//  Enums.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 26/04/2021.
//

import Foundation

//MARK: - ProfileColors
enum ProfileColor: String, CaseIterable {
    case crimson = "crimson"
    case violet = "violet"
    case coolGray = "coolGray"
    case iris = "iris"
    case blackGrape = "blackGrape"
    case trypanBlue = "trypanBlue"
    case persianBlue = "presianBlue"
    case ultramarine = "ultramarine"
    case dodgerBlue = "dodgerBlue"
    case vividSkyBlue = "vividSkyBlue"
    
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
    case history = 0
    case exam = 1
    case profile = 2
}

//MARK: - Exam Type
enum ExamType: String, CaseIterable {
    case resting = "resting"
    case stress = "stress"
    case ambulatory = "ambulatory"
}

//MARK: - Exam Result
public enum ExamResult: String {
    case good = "good"
    case nominal = "regular"
    case bad = "bad"
    case critical = "critical"
}

public enum TimePeriod: Int {
    case week = 7
    case month = 30
    case year = 365
}
