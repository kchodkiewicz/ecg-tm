//
//  Enums.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 26/04/2021.
//

import Foundation

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
    
    static public func ColorName(value: Int64) -> String {
        
        switch value {
        case 0: return "crimson"
        case 1: return "violet"
        case 2: return "coolGray"
        case 3: return "iris"
        case 4: return "blackGrape"
        case 5: return "trypanBlue"
        case 6: return "presianBlue"
        case 7: return "ultramarine"
        case 8: return "dodgerBlue"
        case 9: return "vividSkyBlue"
        default:
            return "crimson"
        }
        
    }
    
    
}

extension ProfileColor: Identifiable {
    var id: ProfileColor { self }
}
