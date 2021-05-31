//
//  Chart.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 24/04/2021.
//

import Charts
import SwiftUI

struct ECGGraph : UIViewRepresentable {
    //Bar chart accepts data as array of BarChartDataEntry objects
    var entries : [ChartDataEntry]
    // this func is required to conform to UIViewRepresentable protocol
    func makeUIView(context: Context) -> LineChartView {
        //crate new chart
        let chart = LineChartView()
        chart.backgroundColor = UIColor(Color.clear) // .systemBackground
        chart.borderColor = .red
        chart.legend.enabled = false
        chart.rightAxis.enabled = true
        chart.leftAxis.labelFont = .boldSystemFont(ofSize: 10)
        chart.leftAxis.labelTextColor = UIColor(.secondary)
        chart.leftAxis.axisLineColor = UIColor(.secondary)
        chart.rightAxis.labelFont = .boldSystemFont(ofSize: 10)
        chart.rightAxis.labelTextColor = UIColor(.secondary)
        chart.rightAxis.axisLineColor = UIColor(.secondary)
        chart.dragYEnabled = false
        chart.scaleYEnabled = false
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.labelFont = .boldSystemFont(ofSize: 10)
        chart.xAxis.labelTextColor = UIColor(.secondary)
        chart.xAxis.axisLineColor = UIColor(.secondary)
        chart.animate(xAxisDuration: 0.5)
        chart.noDataText = "Start new examination"
        //chart.zoom(scaleX: 10, scaleY: 1, x: 0, y: 0)
        
        
        //it is convenient to form chart data in a separate func
        chart.data = addData()
        if chart.data?.entryCount ?? 0 > 0 {
            chart.setVisibleXRangeMaximum(2)
            chart.moveViewToAnimated(xValue: (chart.data?.xMax ?? 0 - 2 < 0 ? 0 : chart.data?.xMax ?? 0 - 2), yValue: 0.0, axis: .left, duration: 0.5, easingOption: .easeInOutBounce)
            
            
        }
        //chart.moveViewToAnimated(xValue: 2, yValue: 0, axis: .left, duration: 0.5)
        return chart
    }
    
    // this func is required to conform to UIViewRepresentable protocol
    func updateUIView(_ uiView: LineChartView, context: Context) {
        //when data changes chart.data update is required
        uiView.data = addData()
        
        if uiView.data?.entryCount ?? 0 > 0 {
            uiView.setVisibleXRangeMaximum(2)
            uiView.moveViewToAnimated(xValue: (uiView.data?.xMax ?? 0 - 2), yValue: 0.0, axis: .left, duration: 0.5, easingOption: .easeInOutBounce)
        }
    }
    
    func addData() -> LineChartData{
        let data = LineChartData()
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.drawCirclesEnabled = false
        dataSet.label = nil
        dataSet.setColor(.systemRed)
        dataSet.lineWidth = 2
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.drawVerticalHighlightIndicatorEnabled = false
        dataSet.highlightColor = UIColor(.primary)
        dataSet.drawValuesEnabled = false
        data.setDrawValues(false)
        
        data.addDataSet(dataSet)
        return data
    }
    
    typealias UIViewType = LineChartView
    
}



struct Chart_Previews: PreviewProvider {
    static var previews: some View {
        ECGGraph(entries: [
            //x - position of a bar, y - height of a bar
            ChartDataEntry(x: 1, y: 1),
            ChartDataEntry(x: 2, y: 2),
            ChartDataEntry(x: 3, y: 3),
            ChartDataEntry(x: 4, y: 0),
            ChartDataEntry(x: 5, y: 7)

        ])
    }
}
