//
//  GraphView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 08/03/2021.
//

import SwiftUI

struct GraphDetail: View {
    
    let frontBackPadding = 10
    var points: [Sample]
    
    var body: some View {
//        VStack {
//            Spacer()
//
//            Path { path in
//                path.move(to: CGPoint(x: frontBackPadding, y: 100))
//                var i = 0
//                for point in points.xValue {
//                    path.addLine(to: CGPoint(x: 100 + i * 50, y: point))
//                    i += 1
//                }
//            }
//            .stroke(Color.red, lineWidth: 2)
//
//            Spacer()
//        }
//        .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)
//        .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 200, idealHeight: 200, maxHeight: 200, alignment: .center)
//        .cornerRadius(10.0)
//        .padding()
//
//
        Text("Graph")
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
