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
    

    @Published public var entries : [ChartDataEntry] = []
    var charts: LineChartView = LineChartView()
    var numOfSample: Int = 0
    //@Published var lineChartData: LineChartData = LineChartData()

//    func initCharts() -> LineChartView
//    {
//        numOfSamble = 0
//        charts = LineChartView()
//
//        charts.backgroundColor = UIColor.systemBackground
//        charts.borderColor = .red
//        charts.rightAxis.enabled = false
//        charts.leftAxis.labelFont = .boldSystemFont(ofSize: 10)
//        charts.leftAxis.labelTextColor = UIColor(.primary)
//        charts.leftAxis.axisLineColor = UIColor(.secondary)
//
//        charts.xAxis.labelPosition = .bottom
//        charts.xAxis.labelFont = .boldSystemFont(ofSize: 10)
//        charts.xAxis.labelTextColor = UIColor(.primary)
//        charts.xAxis.axisLineColor = UIColor(.secondary)
//        charts.scaleYEnabled = false
//        charts.pinchZoomEnabled = false
//        charts.legend.enabled = false
//        charts.doubleTapToZoomEnabled = false
//
//        charts.data = self.addData()
//        return charts
//    }
//
//
//    func addData() -> LineChartData
//    {
//        let data = LineChartData()
//        let dataSet = LineChartDataSet(entries: entries)
//
//        dataSet.drawCirclesEnabled = false
//        dataSet.label = nil
//        dataSet.setColor(UIColor.systemRed)
//        dataSet.lineWidth = 4
//        dataSet.drawHorizontalHighlightIndicatorEnabled = false
//        dataSet.highlightColor = UIColor(.primary)
//        dataSet.drawValuesEnabled  = false
//
//        data.setDrawValues(false)
//        data.addDataSet(dataSet)
//        return data
//    }
//
//    func updateData(data: [ChartDataEntry]) -> LineChartData
//    {
//        let data = LineChartData()
//        let dataSet = LineChartDataSet(entries: entries)
//
//        dataSet.drawCirclesEnabled = false
//        dataSet.label = "My Data"
//        dataSet.setColor(UIColor.systemRed)
//        dataSet.lineWidth = 4
//        dataSet.drawHorizontalHighlightIndicatorEnabled = false
//        dataSet.highlightColor = UIColor.white
//        data.setDrawValues(false)
//        data.addDataSet(dataSet)
//        return data
//    }


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
//            let bytes:[UInt8] = [data[i], data[i+1]]
//            let u16 = UnsafePointer<UInt16>(bytes).memory
            
            //let u16 = UInt16(UInt16(data[i+1]) << COMMShiftByte.OneByte.rawValue + UInt16(data[i]))
            let u16 = UInt16(UInt16(data[i+1]) << COMMShiftByte.OneByte.rawValue + UInt16(data[i ]))
            print("U16 ----- \(u16)")
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
        return self.entries
//
//        let lineChartData = updateData(data: entries)
//        //self.lineChartData = lineChartData
//        return lineChartData
    }
    
    func saveDataToDB() {
    
        numOfSample = 0
        //let tmpDataArray = entries
        
        entries.removeAll()
    
        //return tmpDataArray
    }


}
