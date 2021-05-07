//
//  COMMFrameparser.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 07/05/2021.
//

import Foundation


struct SendFrame {
    var frameID: UInt16
    var frameType: COMMCommandType
}

class COMMFrameParser {

    private var m_listFrame: [SendFrame] = []

    enum FrameType: UInt8
    {
        case SendingFrame = 0x00
        case ResponseFrame = 0x01
        case Invalid = 0xFF
    }

    static func CheckCRC(frame: [UInt8]) -> Bool
    {
        //wylicza CRC
        var emptyData: [UInt8] = []
        if(GetFrameType(frame: frame) == FrameType.SendingFrame)
        {
            let beforeCRC: UInt8 = 4
            let afterCRC: UInt8 = 6
            //emptyData = frame[0...Int(beforeCRC)]
            
            emptyData += frame[0...Int(beforeCRC)]
            emptyData += [0,0]
            emptyData += frame[Int(afterCRC)...frame.count]
            
            //emptyData = frame[afterCRC...frame.count]
            
            let crcValue: UInt16 = COMMFrame.CRC16(data: emptyData)
            let msbCRC: UInt8 = 5
            let lsbCRC: UInt8 = 4
            let crcFrameValue: UInt16 = UInt16((frame[Int(msbCRC)] << COMMShiftByte.OneByte.rawValue + frame[Int(lsbCRC)]))
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
            
            emptyData += frame[0...Int(beforeCRC)]
            emptyData += [0,0]
            emptyData += frame[Int(afterCRC)...frame.count]
            
//            emptyData = frame[0...beforeCRC]
//            emptyData = frame[afterCRC...frame.count]
            
            let crcValue: UInt16 = COMMFrame.CRC16(data: emptyData)
            let msbCRC: UInt8 = 6
            let lsbCRC: UInt8 = 5
            let crcFrameValue: UInt16 = UInt16((frame[Int(msbCRC)] << COMMShiftByte.OneByte.rawValue + frame[Int(lsbCRC)]))
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
    
    private func GetCommandType(frame: [UInt8]) -> COMMCommandType {
        
        let frameID = COMMFrameParser.GetFrameID(frame: frame)
        
        let mIndex = m_listFrame.firstIndex {
            $0.frameID == frameID
        }
        guard mIndex != nil else {
            return COMMCommandType.Invalid
        }
        
        let cmdType = m_listFrame[mIndex!].frameType
        return cmdType
    }
    
    static func ExecuteFrameData(frame: [UInt8])
    {
        if(CheckCRC(frame: frame))
        {
            let frameType: FrameType = GetFrameType(frame: frame)
            if(frameType == FrameType.SendingFrame)
            {
                ExecuteCommand(frame: frame)
            }
            else if(frameType == FrameType.ResponseFrame)
            {
                let cmdType = COMMCommandType.EndECGTest//GetCommandType(frame: frame)
                if  cmdType != COMMCommandType.Invalid
                {
                    let indexAnswerStatus: UInt8 = 4
                    
                    //typy odpowiedzi
                    switch cmdType {
                        case COMMCommandType.EnableModuleECG:

                            if (frame[Int(indexAnswerStatus)] != COMMAnswerType.Ok.rawValue)
                            {
                                print ("Problem z wlaczeniem modulu")
                            }
                            print ("Modul wlaczony")

                        case COMMCommandType.DisableModuleECG:

                            if (frame[Int(indexAnswerStatus)] != COMMAnswerType.Ok.rawValue)
                            {
                                print ("Problem z wylaczeniem modulu")
                            }
                            print("Modul wylaczony")

                        case COMMCommandType.GetModuleECGStatus:

                            if (frame[Int(indexAnswerStatus)] != COMMAnswerType.Ok.rawValue)
                            {
                                print ("Problem z odpowiedzia na temat statusu modulu")
                            }
                            print("Dostalem status modulu")

                        case COMMCommandType.SetDuringTimeECGTest:

                            if (frame[Int(indexAnswerStatus)] != COMMAnswerType.Ok.rawValue)
                            {
                                print ("Problem z ustawieniem czasu")
                            }
                            print("Ustawiony czas wykonywania EKG")

                        case COMMCommandType.StartECGTest:

                            if (frame[Int(indexAnswerStatus)] != COMMAnswerType.Ok.rawValue)
                            {
                                print ("Problem z startem badania")
                            }
                            print("Zaczeto robic badanie EKG")

                        case COMMCommandType.StopECGTest:

                            if (frame[Int(indexAnswerStatus)] != COMMAnswerType.Ok.rawValue)
                            {
                                print ("Problem z zatrzymaniem EKG")
                            }
                            print("Zatrzymano badanie EKG")


                        default:

                            print("Nie znam komendy")

                    }
                }
                else {
                    print("Nie wysylalem takiej ramki")
                }

            }
        }
        else
        {
            print ("Blad CRC")
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
                print("Dostalem paczke danych EKG")

            case COMMCommandType.EndECGTest:
                //informacja o koncu ECG
                print("Skonczylem EKG")

            default:
                print("Nie zna typu komendy")
        }
    }

    static func GetFrameID(frame: [UInt8]) -> UInt16
    {
        var frameID: UInt16 = 0
        let msbID: UInt8 = 2
        let lsbID: UInt8 = 3
        frameID = UInt16((frame[Int(msbID)] << COMMShiftByte.OneByte.rawValue) + frame[Int(lsbID)])
        return frameID
    }

}
