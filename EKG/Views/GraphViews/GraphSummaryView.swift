//
//  GraphView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 09/03/2021.
//

import SwiftUI

struct GraphSummaryView: View {
    
    let points: [Sample]
    
    var body: some View {
        
            VStack {
                
                Spacer()
                
                GraphDetail(points: points)
                
                Spacer()
                
                //TODO: Show / Create / Edit Notes (TextField), pulse?, etc.
                
                Spacer()
                
            }
            .navigationTitle("Examination")
        
        
    }
}

//struct GraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        let point = Sample()
//        GraphSummaryView(points: point)
//    }
//}
