//
//  HistoryItemView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 08/03/2021.
//

import SwiftUI

struct HistoryRow: View {
    
    @ObservedObject var exam: Exam
    @ObservedObject var profile: Profile
    
    //@State private var showingDetail = false
    //@Binding var selection: Bool
    
//    func isShowingDetail() -> Bool {
//        return showingDetail
//    }
    
    func getColor() -> Color {
        
        let heartRate = Double(self.exam.heartRate)
        
        var r: Double {
            if heartRate > 65 && heartRate < 95 {
                return 255.0
            } else if heartRate > 95 {
                return 255.0 + (95 - heartRate)
            } else {
                return 255.0 - heartRate
            }
        }
        
        let g = 35.0
        let b = 75.0
        
        return Color(red: Double(r/255), green: Double(g/255), blue: Double(b/255))
    }
    
    var body: some View {
        
        NavigationLink(
            destination: GraphSummaryView(exam: exam, notes: exam.wrappedNotes, examType: ExamType(rawValue: exam.wrappedType) ?? ExamType.resting),
            label: {
                VStack {
                    
                    HStack(alignment: .top, spacing: 8) {
                        HStack(alignment: .lastTextBaseline, spacing: 0) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.white)
                                .font(.system(.headline, design: .rounded))
                                .padding(.trailing)
                            Text(String(exam.heartRate))
                                .foregroundColor(.white)
                                .font(.system(.headline, design: .rounded))
                            Text("BPM")
                                .foregroundColor(.white)
                                .font(.system(.callout, design: .rounded))
                        }
                        .padding(8)
                        .frame(width: 120, height: 60)
                        .background(getColor())
                        .cornerRadius(10.0)
                        
                        
                        VStack {
                            
                            Text(exam.wrappedDate, formatter: Formatters.dateFormat) // exam.wrappedDate
                                .font(.title3)
                                .bold()
                                .frame(maxWidth: 180.0, alignment: .leading)
                            Text(exam.wrappedNotes)
                                .font(.caption)
                                .lineLimit(3)
                                .frame(maxWidth: 180.0, alignment: .leading)
                            
                        }
                        .frame(maxHeight: 60)
                    }
                }
                
            })
            .isDetailLink(true)
        
    }
}


struct HistoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = PersistenceController.shared.container.viewContext
        
        let testProfile = TestProfile(context: context)
        
        let profiles = try! testProfile.getRows(count: 1)
        
        let profile = profiles[0]
        
        //Group {
        HistoryRow(exam: profile.examArray[0], profile: profile)
        //HistoryRow(exam: profile.examArray[1], profile: profile)
        //}
        //.previewLayout(.fixed(width: 300, height: 70))
    }
}
