//
//  MeanBmpGraph.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 23/05/2021.
//

import SwiftUI

struct MeanBmpGraph: View {
    
    
    @ObservedObject var profile: Profile
    @EnvironmentObject var stats: CardioStatistics
    @State var period: TimePeriod = .week
    
    var body: some View {
        
        TabView(selection: self.$period) {
            if !self.profile.examArray.isEmpty {
                
                VStack {
                HStack(alignment: .bottom) {
                    ForEach(0..<stats.monthlyMean.0.count) { index in
                        
                            Capsule()
                                .fill(Color(self.profile.wrappedColor))
                                .frame(height: 150)// * CGFloat(stats.monthlyMean.0[index]))
                            
                 
                        
                    }
                }
                    HStack(alignment: .bottom) {
                    ForEach(0..<stats.monthlyMean.0.count) { index in
                    Text(index % 4 == 0 ? stats.getDay(date: stats.monthlyMean.1[index]) : "")
                    }
                }
                }
                .tabItem {
                    EmptyView()
                }
                .tag(TimePeriod.month)
                
                HStack(alignment: .bottom) {
                    ForEach(0..<stats.weeklyMean.0.count) { index in
                        VStack {
                            Capsule()
                                .fill(Color(self.profile.wrappedColor))
                                .frame(height: 150 * CGFloat(stats.weeklyMean.0[index]))
                            
                            Text(stats.getDay(date: stats.weeklyMean.1[index]))
                        }
                    }
                }
                .tabItem {
                    EmptyView()
                }
                .tag(TimePeriod.week)
                
            }
            
        }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: 300)
        
        //GeometryReader { proxy in
            
        //}
        
    }
    
    init(profile: Profile) {
        self.profile = profile
        //self.stats = CardioStatistics(profile: self.profile)
    }
}

//struct MeanBmpGraph_Previews: PreviewProvider {
//    static var previews: some View {
//        MeanBmpGraph()
//    }
//}
