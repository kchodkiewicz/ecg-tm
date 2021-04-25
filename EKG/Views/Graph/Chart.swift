//
//  Bar.swift
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
        chart.borderColor = .red
        chart.animate(xAxisDuration: 0.5)
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
        //BarChartDataSet is an object that contains information about your data, styling and more
        let dataSet = LineChartDataSet(entries: entries)
        // change bars color to green
        dataSet.colors = [NSUIColor.green]
        //change data label
        dataSet.label = "My Data"
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
