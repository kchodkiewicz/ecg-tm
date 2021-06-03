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
            GeometryReader {geometry in
                VStack {
                    
                    //VStack(alignment: .leading) {
                        Text(exam.wrappedDate, formatter: Formatters.dateFormat)
                            .font(.system(.title2, design: .rounded))
                            .bold()
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: 450.0, alignment: .leading)
                        Text(ignoreNewLines(exam.wrappedNotes))
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .frame(maxWidth: 450.0, alignment: .leading)
                    //}
                    //.foregroundColor(.primary)
                    //.offset(x: 0.0, y: 50.0)
                    
                    ECGGraphPreview(points: exam.sampleArray)
                        .padding(0)

                }
            }
                
        }
        
    }
}

//struct RecentExamsTabs_Previews: PreviewProvider {
//    static var previews: some View {
//        RecentExamTab()
//    }
//}
