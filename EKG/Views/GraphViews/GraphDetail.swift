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
            
            for i in 0...1000 {
                
                if i % 20 == 0 {
                    self.entries.append( ChartDataEntry(x: Double(i), y: Double.random(in: -1.0...1.0)))
                } else {
                    self.entries.append( ChartDataEntry(x: Double(i), y: Double.random(in: -0.5...0.5)))
                }
                
            }
            
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
