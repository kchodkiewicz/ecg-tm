//
//  RecentExamsTabs.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 23/05/2021.
//

import SwiftUI

struct RecentExamTab: View {
    
    @ObservedObject var exam: Exam
    
    func ignoreNewLines(_ input: String) -> String {
        
        let replaced = input.replacingOccurrences(of: "\n", with: " ")
        
        return replaced
    }
    
    var body: some View {
        NavigationLink(destination: GraphSummaryView(exam: exam, notes: exam.wrappedNotes, examType: ExamType(rawValue: exam.wrappedType) ?? ExamType.resting)) {
            
            ZStack {
                
                ChartPreview(points: exam.sampleArray)
                    .frame(height: 200)
                    //.blur(radius: 1.0, opaque: true)
                    //.opacity(0.7)
                    //.overlay(RecentExamOverlay())
                
                VStack {
                    Text(exam.wrappedDate, formatter: Formatters.dateFormat)
                        .font(.title)
                        .bold()
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: 450.0, alignment: .leading)
                    Text(ignoreNewLines(exam.wrappedNotes))
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .frame(maxWidth: 450.0, alignment: .leading)
                }
                .foregroundColor(.primary)
                //.shadow(radius: 5.0)
                //.background(BlurView(style: .extraLight))
                .offset(x: 0.0, y: 50.0)
                
            }
            
        }
        
        
        
    }
}

//struct RecentExamsTabs_Previews: PreviewProvider {
//    static var previews: some View {
//        RecentExamTab()
//    }
//}
