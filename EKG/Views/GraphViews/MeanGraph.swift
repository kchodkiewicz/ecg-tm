//
//  MeanGraph.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 27/05/2021.
//

import SwiftUI
import Charts


struct MeanGraph : UIViewRepresentable {
    
    var entries : [BarChartDataEntry]
    // this func is required to conform to UIViewRepresentable protocol
    func makeUIView(context: Context) -> BarChartView {
        //crate new chart
        let chart = BarChartView()
        chart.backgroundColor = UIColor.systemBackground
        // visual
        chart.backgroundColor = UIColor(Color.clear) // .systemBackground
        chart.borderColor = .red
        chart.legend.enabled = false
        chart.rightAxis.enabled = true
        chart.leftAxis.enabled = false
        chart.rightAxis.labelFont = .boldSystemFont(ofSize: 10)
        chart.rightAxis.labelTextColor = UIColor(.secondary)
        chart.rightAxis.axisLineColor = UIColor(.secondary)
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.labelFont = .boldSystemFont(ofSize: 10)
        chart.xAxis.labelTextColor = UIColor(.secondary)
        chart.xAxis.axisLineColor = UIColor(.secondary)
        chart.animate(xAxisDuration: 0.5)
        chart.drawGridBackgroundEnabled = false
        
        chart.xAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        
        chart.noDataText = ""
        
        chart.marker = MarkerView()
        
        //touch
        chart.doubleTapToZoomEnabled = false
        chart.dragYEnabled = false
        chart.dragXEnabled = false
        chart.scaleYEnabled = false
        chart.scaleXEnabled = false
        
        //it is convenient to form chart data in a separate func
        chart.data = addData()
        return chart
    }
    
    // this func is required to conform to UIViewRepresentable protocol
    func updateUIView(_ uiView: BarChartView, context: Context) {
        //when data changes chartd.data update is required
        uiView.data = addData()
    }
    
    func addData() -> BarChartData {
        let data = BarChartData()
        
        let dataSet = BarChartDataSet(entries: entries)
        
        dataSet.label = nil
        dataSet.setColor(.systemTeal)
        dataSet.drawValuesEnabled = false
        dataSet.highlightColor = UIColor(.primary)
        
        data.setDrawValues(false)
        data.addDataSet(dataSet)
        return data
    }
    
    init(points: [Peaks]) {
        var data: [BarChartDataEntry] = []
        for index in 0..<points.count {
            let entry = BarChartDataEntry(x: Double(index), y: Double(points[index].xValue))
            data.append(entry)
        }
        self.entries = data
        print(entries)
    }
    
    
    typealias UIViewType = BarChartView

    
}

func getDay(date: Date) -> Double {
    
    let current = Calendar.current
    let day = current.dateComponents([.day], from: date)

    return Double(day.day!)
}

