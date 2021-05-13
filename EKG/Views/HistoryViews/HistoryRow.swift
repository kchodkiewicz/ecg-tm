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
    
    @State private var showingDetail = false
    
    
    func isShowingDetail() -> Bool {
        return showingDetail
    }
    
    var exams_previews: [Sample] {
        var preview: [Sample] = []
        var i = 0
        for sample in exam.sampleArray {
            if i % 25 == 0 {
            preview.append(sample)
            }
            i += 1
        }
        return preview
    }
    
    var body: some View {

        NavigationLink(
            destination: GraphSummaryView(exam: exam, notes: exam.wrappedNotes, examType: ExamType(rawValue: exam.wrappedType) ?? ExamType.resting),
            label: {
                HStack {
                    
                    GraphDetail(points: exams_previews)
                        .frame(width: 150, height: 100)
//                        .transition(Transitions.viewTransition)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        HStack {
                            
                            ExamTag(text: String(exam.heartRate), color: profile.wrappedColor)
                            
                            ExamTag(text: exam.resultName.rawValue, color: profile.wrappedColor)
                            
                            ExamTag(text: exam.wrappedType, color: profile.wrappedColor)
                            
                            Spacer()
                        }
                        
                        Text(exam.wrappedDate, formatter: Formatters.dateFormat)
                            .font(.headline)
                            .bold()
                        Text(exam.wrappedNotes)
                            .font(.caption)
                            .lineLimit(1)
                            .frame(maxWidth: 150.0, alignment: .leading)
                    }
                }
                
            }).buttonStyle(PlainButtonStyle())
        
    }
}

struct ExamTag: View {
    
    var text: String
    var color: String
    
    var body: some View {
        Text("\(text)")
            .foregroundColor(Color(color))
            .font(.caption)
            .padding(4)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(color), lineWidth: 1)
            )
    }
    
}


//struct HistoryItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        let exam = Exam()
//
//        let exam2 = Exam()
//
//        Group {
//            HistoryRow(exam: exam)
//            HistoryRow(exam: exam2)
//        }
//        .previewLayout(.fixed(width: 300, height: 70))
//    }
//}
