//
//  HistoryView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 08/03/2021.
//

import SwiftUI

struct HistoryView: View {
    
    var userData: Profile
    
    var body: some View {
        
//            List {
//    //            Toggle(isOn: $userData.showFavoritesOnly) {
//    //                Text("Show Favorites Only")
//    //            }
//                ForEach(userData.exams) { exam in
//                    NavigationLink(
//                        destination: GraphSummaryView(points: exam.dataPoints)
//                        ) {
//                        HistoryRow(exam: exam)
//                    }
//                }
//            }
//
//            .cornerRadius(10.0)
//            .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)
//            .padding()
//            .navigationBarTitle(Text("History"))
        Text("HistoryView")
        
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        
        HistoryView(userData: Profile())
    }
}
