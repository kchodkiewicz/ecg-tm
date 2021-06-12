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
    
    //let passThroughSubjectPublisher = PassthroughSubject<[ChartDataEntry], Never>()
    @Published public var entries : [ChartDataEntry] = []
    public var y: [Double] = []
    //var charts: LineChartView = LineChartView()
    var numOfSample: Int = 0


    func addDataFromBT(data : [UInt8]) -> [ChartDataEntry]
    {
        
        
        var dataU16T : [UInt16] = []
        let freq: Double = 250
        let gain: Double = 1100
        let offsetError: Double = 1
        let offsetLeads: Double = 330
        let maxValueADC: Double = 1024
        let resolutionAdc: Double = 1023
        
        
        for i in stride(from: 0, to: data.count - 1, by: 2)
        {
            let u16 = UInt16(UInt16(data[i+1]) << COMMShiftByte.OneByte.rawValue + UInt16(data[i]))
            dataU16T.append(u16)
        }
        //print("--U16 \(dataU16T)")
        
        var x: Double = 0
        var tmp: [ChartDataEntry] = []
        for sample in dataU16T
        {
            x = Double(Double(numOfSample) / Double(freq))
            var ecgDisp: Double = Double(sample) * Double(maxValueADC)
            ecgDisp = ecgDisp * (320 / 100)
            ecgDisp = Double(ecgDisp / Double(resolutionAdc))
            ecgDisp = Double((ecgDisp - Double(offsetLeads)) / Double(gain)) - Double(offsetError)

            let entry = ChartDataEntry(x: Double(x), y: Double(ecgDisp))
            tmp.append(entry)
            numOfSample += 1
            y.append(ecgDisp)
        }
        print("numOfSample", numOfSample)
        //print("graphdata entires", self.entries)
        self.entries += tmp
        //passThroughSubjectPublisher.send(tmp)
        //print("entries ", self.entries)
        return self.entries

    }
    
    func saveDataToDB() {
        print(y)
        numOfSample = 0
        //let tmpDataArray = entries
        
        entries.removeAll()
    
        //return tmpDataArray
    }


}
