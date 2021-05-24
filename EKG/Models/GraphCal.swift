//
//  GraphCal.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 13/05/2021.
//

import Foundation
import Charts
import Combine

class GraphCal: ObservableObject, Equatable

{
    static func == (lhs: GraphCal, rhs: GraphCal) -> Bool {
        lhs.entries == rhs.entries
    }
    
    let passThroughSubjectPublisher = PassthroughSubject<[ChartDataEntry], Never>()
    @Published public var entries : [ChartDataEntry] = []
    var charts: LineChartView = LineChartView()
    var numOfSample: Int = 0


    func addDataFromBT(data : [UInt8]) -> [ChartDataEntry]
    {
        
        
        var dataU16T : [UInt16] = []
        let freq = 250
        let gain = 1100
        let offsetError = 1
        let offsetLeads = 330
        let maxValueADC = 1024
        let resolutionAdc = 1023
        
        
        for i in stride(from: 0, to: data.count - 1, by: 2)
        {
            let u16 = UInt16(UInt16(data[i+1]) << COMMShiftByte.OneByte.rawValue + UInt16(data[i ]))
            dataU16T.append(u16)
        }
        
        var x: Double = 0
        var tmp: [ChartDataEntry] = []
        for sample in dataU16T
        {
            x = Double(Double(numOfSample) / Double(freq))
            var ecgDisp = Double(sample) * Double(maxValueADC)
            ecgDisp = ecgDisp * (320 / 100)
            ecgDisp = Double(ecgDisp / Double(resolutionAdc))
            ecgDisp = Double((ecgDisp - Double(offsetLeads)) / Double(gain)) - Double(offsetError)

            let entry = ChartDataEntry(x: Double(x), y: Double(ecgDisp))
             tmp.append(entry)
             numOfSample += 1
        }
        
        
        
        self.entries += tmp
        passThroughSubjectPublisher.send(tmp)
        return self.entries

    }
    
    func saveDataToDB() {
    
        numOfSample = 0
        //let tmpDataArray = entries
        
        entries.removeAll()
    
        //return tmpDataArray
    }


}
