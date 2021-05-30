//
//  ChartPreview.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 15/05/2021.
//

import Charts
import SwiftUI

struct ChartPreview : UIViewRepresentable {
    //Bar chart accepts data as array of BarChartDataEntry objects
    var entries : [ChartDataEntry]
    // this func is required to conform to UIViewRepresentable protocol
    func makeUIView(context: Context) -> LineChartView {
        //crate new chart
        let chart = LineChartView()
        chart.backgroundColor = UIColor.clear
        // visual
        //chart.borderColor = .red
        chart.rightAxis.enabled = false
        chart.leftAxis.enabled = false
        chart.legend.enabled = false
        chart.drawGridBackgroundEnabled = false
        chart.xAxis.enabled = false
        
        
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
        dataSet.drawValuesEnabled = false
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.drawVerticalHighlightIndicatorEnabled = false
        dataSet.highlightColor = UIColor(.primary)
        
        data.setDrawValues(false)
        data.addDataSet(dataSet)
        return data
    }
    
    init(points: [Sample]) {
        var data: [ChartDataEntry] = []
        for point in points {
            let entry = ChartDataEntry(x: Double(point.xValue), y: Double(point.yValue))
            data.append(entry)
        }
        self.entries = data
    }
    
    typealias UIViewType = LineChartView
    
}



struct ChartPreview_Previews: PreviewProvider {
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

