//
//  GraphView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 08/03/2021.
//

import SwiftUI
import Charts

struct GraphDetail: View {
    
    let frontBackPadding = 10
    var entries = [ChartDataEntry]()
    
    var body: some View {
        ECGGraph(entries: entries)
//            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10.0, height: 10.0)))
//            .shadow(radius: 10.0)
    }
    
    init(points: [Sample]) {
        
        self.entries = []
        
        guard !points.isEmpty else {
            print("Recieved empty array. Creating default [Sample]")
            self.entries = [
                ChartDataEntry(x: 1.0, y: 1.0),
                ChartDataEntry(x: 2.0, y: 1.1),
                ChartDataEntry(x: 3.0, y: 2.1),
                ChartDataEntry(x: 4.0, y: 0.8),
                ChartDataEntry(x: 5.0, y: 1.0),
                ChartDataEntry(x: 6.0, y: 1.4),
                ChartDataEntry(x: 7.0, y: 1.8)
            ]
            return
        }
        
        for point in points {
            let entry = ChartDataEntry(x: Double(point.xValue), y: Double(point.yValue))
            self.entries.append(entry)
        }
        
    }
        
}

//struct GraphDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let point = Sample()
//                
//        GraphDetail(points: point)
//            .previewLayout(.fixed(width: 500, height: 300))
//    }
//}
