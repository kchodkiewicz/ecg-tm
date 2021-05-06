import Foundation
import COMMFrame
import COMMShiftByte
import COMMCommandType
import COMMAnswerType


class COMMFrameParser {

    private var m_listFrame: [ frameID: UInt16, frameType: COMMCommandType]
    
    enum FrameType: UInt8
    {
        case SendingFrame = 0x00
        case ResponseFrame = 0x01
        case Invalid = 0xFF
    }

    static func CheckCRC(frame: [UInt8]]) -> Bool
    {
        //wylicza CRC
        var emptyData = [UInt8](count:frame.size(), repeatedValue: 0)
        if(GetFrameType(frame) == FrameType::SendingFrame)
        {
            var beforeCRC: UInt8 = 4
            var afterCRC: UInt8 = 6
            emptyData = frame[0..beforeCRC]
            emptyData = frame[afterCRC..frame.size()]
            var crcValue: UInt16 = COMMFrame.CRC16(emptyData)
            var msbCRC: UInt8 = 5
            var lsbCRC: UInt8 = 4
            var crcFrameValue: UInt16 = (frame[msbCRC] << COMMShiftByte.OneByte + frame[lsbCRC])
            if (crcValue != crcFrameValue)
            {
                return false
            }
            return true
        }
        else
        {
            var beforeCRC: UInt8 = 5
            var afterCRC: UInt8 = 7
            emptyData = frame[0..beforeCRC]
            emptyData = frame[afterCRC..frame.size()]
            var crcValue: UInt16 = COMMFrame.CRC16(emptyData)
            var msbCRC: UInt8 = 6
            var lsbCRC: UInt8 = 5
            var crcFrameValue: UInt16 = (frame[msbCRC] << COMMShiftByte.OneByte + frame[lsbCRC])
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
        var header1: UInt8 = 0x55
        var header2: UInt8 = 0xAA

        if(frame[0] == header1)
        {
            return FrameType.ResponseFrame
        }
        else if (frame[0] == header2)
        {
            return FrameType.SendingFrame
        }
    }

    static func ExecuteFrameData(frame: [UInt8])
    {
        if(CheckCRC(frame))
        {
            var frameType: FrameType = GetFrameType(frame)
            if(frameType == FrameType.SendingFrame)
            {
                ExecuteCommand(frame)
            }
            else if(frameType == FrameType.ResponseFrame)
            {
                let frameID = GetFrameID(frame)
                if let cmdType = m_listFrame[frameID]
                {
                    var indexAnswerStatus: UInt8 = 4
                    //typy odpowiedzi
                    switch cmdType{
                        case COMMCommandType.EnableModuleECG:
                        {
                            if (frame[indexAnswerStatus] != COMMAnswerType.Ok)
                            {
                                print ("Problem z wlaczeniem modulu")
                            }
                            print ("Modul wlaczony")
                        }
                        case COMMCommandType.DisableModuleECG:
                        {
                            if (frame[indexAnswerStatus] != COMMAnswerType.Ok)
                            {
                                print ("Problem z wylaczeniem modulu")
                            }
                            print("Modul wylaczony")
                        }
                        case COMMCommandType.GetModuleECGStatus:
                        {
                            if (frame[indexAnswerStatus] != COMMAnswerType.Ok)
                            {
                                print ("Problem z odpowiedzia na temat statusu modulu")
                            }
                            print("Dostalem status modulu")
                        }
                        case COMMCommandType.SetDuringTimeECGTest:
                        {
                            if (frame[indexAnswerStatus] != COMMAnswerType.Ok)
                            {
                                print ("Problem z ustawieniem czasu")
                            }
                            print("Ustawiony czas wykonywania EKG")
                        }
                        case COMMCommandType.StartECGTest:
                        {
                            if (frame[indexAnswerStatus] != COMMAnswerType.Ok)
                            {
                                print ("Problem z startem badania")
                            }
                            print("Zaczeto robic badanie EKG")
                        }
                        case COMMCommandType.StopECGTest:
                        {
                            if (frame[indexAnswerStatus] != COMMAnswerType.Ok)
                            {
                                print ("Problem z zatrzymaniem EKG")
                            }
                            print("Zatrzymano badanie EKG")
            
                        }
                        default:
                        {
                            print("Nie znam komendy")
                        }
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
        let frameID = GetFrameID(frame)

        var commandIndex: UInt8 = 7
        var commandType: COMMCommandType = frame[commandIndex]

        switch commandType{
            case COMMCommandType.ECGSamplePackage:{
                //odpakuj te dane
                print("Dostalem paczke danych EKG")
            }
            case COMMCommandType.EndECGTest:{
                //informacja o koncu ECG
                print("Skonczylem EKG")
            }
            default:{
                print("Nie zna typu komendy")
            }

        }
    }

    static func GetFrameID(frame: [UInt8]) -> UInt16
    {
        var frameID: UInt16 = 0
        var msbID: UInt8 = 2
        var lsbID: UInt8 = 3
        frameID = (data[msbID] << ShiftByte.OneByte) + data[lsbID]
        return frameID
    }

}