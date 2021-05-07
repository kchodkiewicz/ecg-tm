//
//  Chart.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 24/04/2021.
//

import Charts
import SwiftUI

struct Chart : UIViewRepresentable {
    //Bar chart accepts data as array of BarChartDataEntry objects
    var entries : [ChartDataEntry]
    // this func is required to conform to UIViewRepresentable protocol
    func makeUIView(context: Context) -> LineChartView {
        //crate new chart
        let chart = LineChartView()
        chart.backgroundColor = UIColor.systemBackground
        chart.borderColor = .red
        chart.rightAxis.enabled = false
        chart.leftAxis.labelFont = .boldSystemFont(ofSize: 10)
        chart.leftAxis.labelTextColor = UIColor(.primary)
        chart.leftAxis.axisLineColor = UIColor(.secondary)
        
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.labelFont = .boldSystemFont(ofSize: 10)
        chart.xAxis.labelTextColor = UIColor(.primary)
        chart.xAxis.axisLineColor = UIColor(.secondary)
        
        
        //it is convenient to form chart data in a separate func
        chart.data = addData()
        return chart
    }
    
    // this func is required to conform to UIViewRepresentable protocol
    func updateUIView(_ uiView: LineChartView, context: Context) {
        //when data changes chartd.data update is required
        uiView.data = addData()
    }
    
    func addData() -> LineChartData{
        let data = LineChartData()
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.drawCirclesEnabled = false
        dataSet.label = nil
        dataSet.setColor(.systemRed)
        dataSet.lineWidth = 4
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.drawVerticalHighlightIndicatorEnabled = false
        dataSet.highlightColor = UIColor(.primary)
        
        data.setDrawValues(false)
        data.addDataSet(dataSet)
        return data
    }
    
    typealias UIViewType = LineChartView
    
}



struct Chart_Previews: PreviewProvider {
    static var previews: some View {
        Chart(entries: [
            //x - position of a bar, y - height of a bar
            ChartDataEntry(x: 1, y: 1),
            ChartDataEntry(x: 2, y: 2),
            ChartDataEntry(x: 3, y: 3),
            ChartDataEntry(x: 4, y: 0),
            ChartDataEntry(x: 5, y: 7)

        ])
    }
}
