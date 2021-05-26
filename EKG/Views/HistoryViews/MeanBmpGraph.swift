//
//  MeanBmpGraph.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 23/05/2021.
//

import SwiftUI

struct MeanBmpGraph: View {
    
    @ObservedObject var profile: Profile
    var period: TimePeriod
    
    
    func heightRatio(_ heartRates: [Double], forIndex: Int) -> CGFloat {
        guard let max = heartRates.max() else { return CGFloat(0) }
        
        let ratio = heartRates[forIndex] / max
        
        return CGFloat(ratio)
    }
    
    var heartRates: ([Double], [Date]) {
        var heartRates: [Double] = []
        var dates: [Date] = []
        for i in 0...period.rawValue {
            
            let evaluatedDate = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
            
            let examsOfADay = self.profile.examArray.filter { Exam in
                Calendar.current.isDate(evaluatedDate, inSameDayAs: Exam.wrappedDate)
            }
            
            var sum = 0
            
            for exam in examsOfADay {
                sum += exam.heartRate
            }
            if examsOfADay.count > 0 {
                
                let mean: Double = Double(sum) / Double(examsOfADay.count)
                
                heartRates.append(mean)
                dates.append(evaluatedDate)
            } else {
                heartRates.append(0.0)
                dates.append(evaluatedDate)
            }
        }
        return (heartRates.reversed(), dates.reversed())
    }
    
    private func getDay(date: Date) -> String {
        
        let current = Calendar.current
        let day = current.dateComponents([.day], from: date)

        return String(day.day!)
    }
    
    var body: some View {
        
        //GeometryReader { proxy in
            HStack(alignment: .bottom) {
                ForEach(0..<heartRates.0.count) { index in
                    VStack {
                        Capsule()
                            .fill(Color(self.profile.wrappedColor))
                            .frame(height: 150 * heightRatio(heartRates.0, forIndex: index))
                            //.offset(x: CGFloat(10 * index), y: 0.0) //200 * (1 - heightRatio(heartRates, forIndex: index))
                        
                        Text(period == .week || index % 5 == 0 ? getDay(date: heartRates.1[index]) : "")
                        
                    }
                    //.animation(.ripple(index: index))
                }
                //.offset(x: 0, y: proxy.size.height * heightRatio)
            }
        //}
        
    }
}

//struct MeanBmpGraph_Previews: PreviewProvider {
//    static var previews: some View {
//        MeanBmpGraph()
//    }
//}
