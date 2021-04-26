//
//  HistoryItemView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 08/03/2021.
//

import SwiftUI

struct HistoryRow: View {
    
    var exam: Exam
  
    @State private var showingDetail = false

    
    func isShowingDetail() -> Bool {
        return showingDetail
    }
    
    var body: some View {
        VStack {
            HStack {

                GraphDetail(points: exam.sampleArray)
                    .frame(width: 50, height: 30)


                VStack(alignment: .leading) {
                    Text(exam.date ?? Date(), formatter: Formatters.dateFormat)
                        .font(.headline)
                }

                Spacer()


                Button(action: {
                    withAnimation {
                        self.showingDetail.toggle()
                    }
                }) {
                    Image(systemName: "chevron.right.circle")
                        .imageScale(.large)
                        .rotationEffect(.degrees(showingDetail ? 90 : 0))
                        .scaleEffect(showingDetail ? 1.5 : 1)
                        .padding()
                }

            }

            if isShowingDetail() {
                NavigationLink (
                    destination: GraphSummaryView(points: exam.sampleArray),
                    label: {
                        ZStack {
                            GraphDetail(points: exam.sampleArray)
                                .frame(height: 100)
                                .transition(Transitions.viewTransition)
                            EmptyView()
                    }
                        
                        
                    }).buttonStyle(PlainButtonStyle())
                    

            }
        }
        .buttonStyle(PlainButtonStyle())

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
