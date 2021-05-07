//
//  COMMAnswerType.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 07/05/2021.
//

import Foundation


enum COMMAnswerType: UInt8
{
    case NotImplemented = 0x00
    case Ok = 0x01
    case NotExecuted = 0x02
    case DuringExecution = 0x03
    case ErrorCRC = 0x05

    case Invalid = 0xFF
}
