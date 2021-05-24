//
//  HistoryOverview.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 23/05/2021.
//

import SwiftUI

struct HistoryOverview: View {
    
    @ObservedObject var profile: Profile
    @Binding var switchTab: Tab
    @State var selectPeriod: TimePeriod = .week
    
    var body: some View {
        
        List {
        
            
            TabView {
                if profile.examArray.count > 0 {
                    ForEach(Range(0...min(2, profile.examArray.count - 1))) {index in
                        RecentExamTab(exam: profile.examArray[index])
                            .tabItem {
                                Text(profile.examArray[index].wrappedDate, formatter: Formatters.dateFormat)
                            }
                            .tag(index)
                    }
//                RecentExamTab(exam: profile.examArray[0])
//                    .tabItem {
//                        Text("Last Exam")
//                    }
//                    .tag(1)
//
//                RecentExamTab(exam: profile.examArray[1])
//                    .tabItem {
//                        Text("One but Last Exam")
//                    }
//                    .tag(2)
//
//                RecentExamTab(exam: profile.examArray[2])
//                    .tabItem {
//                        Text("Two but Last Exam")
//                    }
//                    .tag(3)
                } else {
                    Button {
                        switchTab = .exam
                    } label: {
                        Text("Make first examination")
                            .padding()
                            
                    }.background(Color(self.profile.wrappedColor))
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .cornerRadius(CGFloat(20.0))
                    

                    
                }
                
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 200)
            
            TabView(selection: self.$selectPeriod) {
                if self.profile.examArray.count > 0 {
                
//                    MeanBmpGraph(profile: self.profile, period: .month)
//                        .tabItem {
//                            EmptyView()
//                        }
//                        .tag(TimePeriod.month)
                    
                    MeanBmpGraph(profile: self.profile, period: .week)
                        .tabItem {
                            EmptyView()
                        }
                        .tag(TimePeriod.week)
                        
                }

            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 200)
            
            HistoryView(filter: profile.wrappedId)
            
            
            
        }.listStyle(PlainListStyle())
        
        .navigationTitle("Overview")
    }
}

//struct HistoryOverview_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryOverview(profile: Profile()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
