//
//  HistoryItemView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 08/03/2021.
//

import SwiftUI

struct HistoryRow: View {
    
    var exam: Exam
  
    @State private var showDetail = false
    
    var transition: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    func isShowingDetail() -> Bool {
        return showDetail
    }

    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
//        VStack {
//            HStack {
//
//                GraphDetail(points: exam.dataPoints)
//                    .frame(width: 50, height: 30)
//
//
//                VStack(alignment: .leading) {
//                    Text(exam.date, formatter: HistoryRow.dateFormat)
//                        .font(.headline)
//                }
//
//                Spacer()
//
//
//                Button(action: {
//                    withAnimation {
//                        self.showDetail.toggle()
//                    }
//                }) {
//                    Image(systemName: "chevron.right.circle")
//                        .imageScale(.large)
//                        .rotationEffect(.degrees(showDetail ? 90 : 0))
//                        .scaleEffect(showDetail ? 1.5 : 1)
//                        .padding()
//                }
//
//            }
//
//            if isShowingDetail() {
//                NavigationLink(
//                    destination: GraphSummaryView(points: exam.dataPoints),
//                    label: {
//                        GraphDetail(points: exam.dataPoints)
//                            .padding(.top, 40)
//                            .transition(transition)
//                    })
//
//            }
//        }
        Text("History")
    }
}

struct HistoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        let exam = Exam()
        
        let exam2 = Exam()
        
        Group {
            HistoryRow(exam: exam)
            HistoryRow(exam: exam2)
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
