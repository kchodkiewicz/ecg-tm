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
    var points: [Sample]
    var entries = [ChartDataEntry]()
    
    var body: some View {
        
        Chart(entries: entries)
    }
    
    init(points: [Sample]) {
        self.entries = []
        self.points = points
        for point in self.points {
            let entry = ChartDataEntry(x: Double(Int(point.xValue)), y: Double(point.yValue))
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
