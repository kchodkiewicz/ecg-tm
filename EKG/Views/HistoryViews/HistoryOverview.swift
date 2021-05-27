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
        ScrollView {
            VStack {
                
                
                TabView {
                    if !profile.examArray.isEmpty {
                        //                    ForEach(profile.examArray.filter({ Exam in
                        //
                        //                        Calendar.current.isDate(Exam.wrappedDate, inSameDayAs: Date())
                        //
                        //                    })) { exam in
                        //                        RecentExamTab(exam: exam)
                        //                            .tabItem {
                        //                                Text(exam.wrappedDate, formatter: Formatters.dateFormat)
                        //                            }
                        //                            .tag(exam.wrappedId)
                        //                    }
                        
                        RecentExamTab(exam: profile.examArray[0])
                            .tabItem {
                                Text("Last Exam")
                            }
                            .tag(1)
                        if profile.examArray.count > 1 {
                            RecentExamTab(exam: profile.examArray[1])
                                .tabItem {
                                    Text("One but Last Exam")
                                }
                                .tag(2)
                        }
                        if profile.examArray.count > 2 {
                            RecentExamTab(exam: profile.examArray[2])
                                .tabItem {
                                    Text("Two but Last Exam")
                                }
                                .tag(3)
                        }
                    } else {
                        Button {
                            switchTab = .exam
                        } label: {
                            Text("Make first examination")
                        }
                        
                    }
                    
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 200)
                
                MeanBmpGraph(profile: self.profile)
                
            }
        }
        
        .navigationTitle("Overview")
    }
}

//struct HistoryOverview_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryOverview(profile: Profile()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
