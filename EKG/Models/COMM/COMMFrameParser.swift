//
//  COMMFrameparser.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 07/05/2021.
//

import Combine
import Foundation



class COMMFrameParser: ObservableObject {
    
    struct SendFrame {
        var frameID: UInt16
        var frameType: COMMCommandType
    }
    
    static var ecgFinished: Bool = false
    static var frameEntries: [UInt8] = []
    
    private static var m_listFrame: [SendFrame] = []
    private static var m_isTestingECG: Bool = false
    private static var m_countECGFrame: Int = 0
    
    private static var m_isSamplePackage: Bool = false
    
    private static var frameExecution: [UInt8] = []
    
    enum FrameType: UInt8
    {
        case SendingFrame = 0x00
        case ResponseFrame = 0x01
        case Invalid = 0xFF
    }
    
    static func EnableECGTest()
    {
        m_isTestingECG = true
    }

    static func DisableECGTest()
    {
        m_isTestingECG = false
    }

    static func CheckCRC(frame: [UInt8]) -> Bool
    {
        if COMMFrameParser.m_isTestingECG {
            print("m_isTesting jest true")
            return true
        }
        //wylicza CRC
        var emptyData: [UInt8] = []
        if(GetFrameType(frame: frame) == FrameType.SendingFrame)
        {
            print("sprawdzam CRC sending frejma")
            let beforeCRC: UInt8 = 4
            let afterCRC: UInt8 = 6
            //emptyData = frame[0...Int(beforeCRC)]
            
            emptyData += frame[0...Int(beforeCRC) - 1]
            emptyData += [0, 0]
            emptyData += frame[Int(afterCRC)...frame.count - 1]
            
            //emptyData = frame[afterCRC...frame.count]
            
            let crcValue: UInt16 = COMMFrame.CRC16(data: emptyData)
            let msbCRC: UInt8 = 5
            let lsbCRC: UInt8 = 4
            let crcFrameValue: UInt16 = UInt16(UInt16(frame[Int(msbCRC)]) << COMMShiftByte.OneByte.rawValue + UInt16(frame[Int(lsbCRC)]))
            if (crcValue != crcFrameValue)
            {
                return false
            }
            return true
        }
        else
        {
            let beforeCRC: UInt8 = 5
            let afterCRC: UInt8 = 7
            
            emptyData += frame[0...Int(beforeCRC) - 1]
            emptyData += [0, 0]
            emptyData += frame[Int(afterCRC)...frame.count - 1]
            
            //            emptyData = frame[0...beforeCRC]
            //            emptyData = frame[afterCRC...frame.count]
            
            let crcValue: UInt16 = COMMFrame.CRC16(data: emptyData)
            let msbCRC: UInt8 = 6
            let lsbCRC: UInt8 = 5
            let crcFrameValue: UInt16 = UInt16(UInt16(frame[Int(msbCRC)]) << COMMShiftByte.OneByte.rawValue + UInt16(frame[Int(lsbCRC)]))
            if (crcValue != crcFrameValue)
            {
                return false
            }
            return true
        }
    }
    
    static func GetFrameType(frame: [UInt8]) -> FrameType
    {
        //Zwraca typ ramki
        let header1: UInt8 = 0x55
        let header2: UInt8 = 0xAA
        
        if(frame[0] == header1)
        {
            return FrameType.ResponseFrame
        }
        else if (frame[0] == header2)
        {
            return FrameType.SendingFrame
        }
        
        return FrameType.Invalid
    }
    
    static func SetCommandType(frameId: UInt16, type: COMMCommandType) {
        self.m_listFrame.append(SendFrame(frameID: frameId, frameType: type))
    }
    
    static func GetCommandType(frame: [UInt8]) -> COMMCommandType {
        
        let frameID = COMMFrameParser.GetFrameID(frame: frame)
        
        let mIndex = m_listFrame.firstIndex {
            $0.frameID == frameID
        }
        guard mIndex != nil else {
            return COMMCommandType.Invalid
        }
        
        let cmdType = m_listFrame.remove(at: mIndex!).frameType
        
        return cmdType
    }
    
    static func ExecuteFrameData(frame: [UInt8]) {
        let frameType: FrameType = GetFrameType(frame: frame)
        var tmpFrame: [UInt8] = []
        print("-#-#- wykouje komende")
        
        if frameType == FrameType.SendingFrame || m_isSamplePackage == true {
            
            var getFrame = false
            let commandIndex: UInt8 = 7
            let commandType: COMMCommandType = COMMCommandType(rawValue: frame[Int(commandIndex)]) ?? COMMCommandType.Invalid
            print("Musze sprawdzic dane ekg")
            if m_isSamplePackage == true {
                
                if frameExecution.count < 238 {
                    frameExecution += frame
                    print("Dostałem część próbek")
                    return
                }
                
                frameExecution += frame
                m_isSamplePackage = false
                tmpFrame = frameExecution
                frameExecution.removeAll()
                print("Dostałem całą ramkę")
                getFrame = true
            }
            if commandType == COMMCommandType.ECGSamplePackage && !getFrame {
                m_isSamplePackage = true
                frameExecution += frame
                print("Dostałem początek ramki próbkami")
                return
            }
            else if commandType == COMMCommandType.EndECGTest {
                tmpFrame = frame
            }
        } else {
            tmpFrame = frame
            print("typ ramki", frameType)
            print(tmpFrame)
        }
        if CheckCRC(frame: tmpFrame) {
            let frameType: FrameType = GetFrameType(frame: tmpFrame)
            print("jestem przez ifem tym o takim")
            if frameType == FrameType.SendingFrame {
                print("dostałem ramke bo tym to sending frame")
                ExecuteCommand(frame: tmpFrame)
            }
            else if frameType == FrameType.ResponseFrame {
                let cmdType = GetCommandType(frame: tmpFrame)
                if  cmdType != COMMCommandType.Invalid {
                    let indexAnswerStatus: UInt8 = 4
                    
                    //typy odpowiedzi
                    switch cmdType {
                    case COMMCommandType.EnableModuleECG:
                        
                        if (tmpFrame[Int(indexAnswerStatus)] != COMMAnswerType.Ok.rawValue) {
                            print ("Problem z wlaczeniem modulu")
                        } else {
                            print ("Modul wlaczony")
                        }
                        
                    case COMMCommandType.DisableModuleECG:
                        
                        if (tmpFrame[Int(indexAnswerStatus)] != COMMAnswerType.Ok.rawValue) {
                            print ("Problem z wylaczeniem modulu")
                        } else {
                            print("Modul wylaczony")
                        }
                    case COMMCommandType.GetModuleECGStatus:
                        
                        if (tmpFrame[Int(indexAnswerStatus)] != COMMAnswerType.Ok.rawValue) {
                            print ("Problem z odpowiedzia na temat statusu modulu")
                        } else {
                            print("Dostalem status modulu")
                        }
                    case COMMCommandType.SetDuringTimeECGTest:
                        
                        if (tmpFrame[Int(indexAnswerStatus)] != COMMAnswerType.Ok.rawValue) {
                            print ("Problem z ustawieniem czasu")
                        } else {
                            print("Ustawiony czas wykonywania EKG")
                        }
                    case COMMCommandType.StartECGTest:
                        
                        if (tmpFrame[Int(indexAnswerStatus)] != COMMAnswerType.Ok.rawValue) {
                            print ("Problem z startem badania")
                        } else {
                            COMMFrameParser.EnableECGTest()
                            print("Rozpoczęto badanie EKG")
                        }
                    case COMMCommandType.StopECGTest:
                        
                        if (tmpFrame[Int(indexAnswerStatus)] != COMMAnswerType.Ok.rawValue) {
                            print ("Problem z zatrzymaniem EKG")
                        } else {
                            COMMFrameParser.DisableECGTest()
                            print("Zatrzymano badanie EKG")
                        }
                    default:
                        print("Nie znam komendy")
                    }
                }
                else {
                    print("Nie wysylalem takiej ramki")
                }
                
            }
        }
        else {
            print("Blad CRC")
        }
    }
    
    static func ExecuteCommand(frame: [UInt8])
    {
        //let frameID = GetFrameID(frame: frame)
        
        let commandIndex: UInt8 = 7
        let commandType: COMMCommandType = COMMCommandType(rawValue: frame[Int(commandIndex)]) ?? COMMCommandType.Invalid
        
        switch commandType{
        case COMMCommandType.ECGSamplePackage:
            //odpakuj te dane
            
            COMMFrameParser.frameEntries = Array(frame[8...frame.count - 1])
            COMMFrameParser.ecgFinished = true
            
            print("Dostalem paczke danych EKG")
            
        case COMMCommandType.EndECGTest:
            //informacja o koncu ECG
            print("Skonczylem EKG")
            //self.ecgFinished = true
            
        default:
            print("Nie znam typu komendy")
        }
    }
    
    static func GetFrameID(frame: [UInt8]) -> UInt16 {
        var frameID: UInt16 = 0
        let msbID: UInt8 = 2
        let lsbID: UInt8 = 3
        frameID = UInt16((frame[Int(msbID)] << COMMShiftByte.OneByte.rawValue) + frame[Int(lsbID)])
        return frameID
    }
    
}
