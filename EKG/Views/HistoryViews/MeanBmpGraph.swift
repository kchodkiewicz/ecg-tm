////
////  MeanBmpGraph.swift
////  EKG
////
////  Created by Krzysztof Chodkiewicz on 23/05/2021.
////
//
//import SwiftUI
//
//struct MeanBmpGraph: View {
//
//
//    @ObservedObject var profile: Profile
//    //@EnvironmentObject var stats: CardioStatistics
//    @State var period: TimePeriod = .week
//
//    var body: some View {
//
//        if !self.profile.examArray.isEmpty {
//            TabView(selection: self.$period) {
//
//                //                MeanGraph(points: self.stats.monthlyMean)
//                //                .tabItem {
//                //                    EmptyView()
//                //                }
//                //                .tag(TimePeriod.month)
//                //
//                //                MeanGraph(points: self.stats.weeklyMean)
//                //                .tabItem {
//                //                    EmptyView()
//                //                }
//                //                .tag(TimePeriod.week)
//
//            }
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//            .frame(height: 300)
//        }
//    }
//
//    init(profile: Profile) {
//        self.profile = profile
//        //self.stats = CardioStatistics(profile: self.profile)
//    }
//}
//
////struct MeanBmpGraph_Previews: PreviewProvider {
////    static var previews: some View {
////        MeanBmpGraph()
////    }
////}
