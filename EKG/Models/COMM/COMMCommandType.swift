import Foundation


enum COMMCommandType: UInt8
{
    case EnableModuleECG = 0x01
    case DisableModuleECG = 0x02
    case GetModuleECGStatus = 0x03

    case SetDuringTimeECGTest  = 0x12
    case StartECGTest = 0x13
    case StopECGTest = 0x14
    case ECGSamplePackage = 0x15
    case EndECGTest = 0x16

    case Invalid = 0xFF
}