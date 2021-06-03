//
//  PeaksGroupBox.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 28/05/2021.
//
import SwiftUI

class CardioStats {
    var meanTime: Double = 0.0
    var variation: Double = 0.0
    var median: Double = 0.0
    var times: [Double] = []
    
    var exam: Exam
    
    init(exam: Exam) {
        self.exam = exam
    }
    
    func getStats() -> CardioStats {
        var times: [Double] = []
        
        var peaksConverted: [Double] = []
        
        var arr: [Double] = []
        for peaks in exam.peaksArray {
            arr.append(peaks.xValue)
        }
        // remove duplicates
        let tmpSet = Set<Double>(arr)
        
        peaksConverted = Array<Double>(tmpSet).sorted()
        
        guard peaksConverted.count > 1 else {
            return self
        }
        
        for index in 1..<peaksConverted.count {
            let lhs = peaksConverted[index]
            let rhs = peaksConverted[index - 1]
            times.append(abs(lhs - rhs))
        }
        
        let sum: Double = times.reduce(0, { a, b in
            return a + b
        })
        
        let meanTime = sum / Double(times.count)
        
        var median: Double {
            let sorted: [Double] = times.sorted()
            let length = times.count
            if (length % 2 == 0) {
                    return (Double(sorted[length / 2 - 1]) + Double(sorted[length / 2])) / 2.0
            } else {
                return Double(sorted[length / 2])
            }
        }
        
        let variation = times.sorted()[Int(Double(times.count) * 0.75)] - times.sorted()[Int(Double(times.count) * 0.25)]
        
        self.meanTime = meanTime
        self.median = median
        self.variation = variation
        self.times = times
        
        return self
    }
    
}

struct PeaksGroupBox: View {
    
    var exam: Exam
    @State var isShowingGraph: Bool = false
    
    var stats: CardioStats
    
    var body: some View {
        
        GroupBox(label:
                    Label("Rhythm", systemImage: "metronome.fill")
                    .foregroundColor(Color(UIColor.systemGreen))
        ) {
            Button {
                withAnimation {
                    if !self.exam.peaksArray.isEmpty {
                        self.isShowingGraph.toggle()
                    }
                }
            } label: {
                if self.isShowingGraph {
                    MeanGraph(points: self.stats.times)
                        .frame(height: 400)
                } else {
                    
                    HStack {
                        Spacer()
                        VStack(alignment: .center)  {
                            Text("Interval")
                                .font(.system(.headline, design: .rounded))
                                .bold()
                                .foregroundColor(Color(.systemRed))
                            HStack(alignment: .lastTextBaseline, spacing: 0) {
                                Text("\(Int(1000 * self.stats.meanTime))")
                                    .font(.system(.largeTitle, design: .rounded))
                                    .bold()
                                Text("ms")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Divider()
                        
                        VStack(alignment: .center) {
                            Text("Median")
                                .font(.system(.headline, design: .rounded))
                                .bold()
                                .foregroundColor(Color(.systemBlue))
                            HStack(alignment: .lastTextBaseline, spacing: 0) {
                                Text("\(Int(1000 * self.stats.median))")
                                    .font(.system(.largeTitle, design: .rounded))
                                    .bold()
                                Text("ms")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Divider()
                        
                        VStack(alignment: .center) {
                            Text("IQR")
                                .font(.system(.headline, design: .rounded))
                                .bold()
                                .foregroundColor(Color(.systemGreen))
                            HStack(alignment: .lastTextBaseline, spacing: 0) {
                                Text("\(Int(1000 * self.stats.variation))")
                                    .font(.system(.largeTitle, design: .rounded))
                                    .bold()
                                Text("ms")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                    }.allowsTightening(true)
                    
                    
                }
            }
            .buttonStyle(PlainButtonStyle())
            
        }
    }
    
    init(exam: Exam) {
        self.exam = exam
        self.stats = CardioStats(exam: self.exam).getStats()
        
        
    }
}

//struct PeaksGroupBox_Previews: PreviewProvider {
//    static var previews: some View {
//        PeaksGroupBox()
//    }
//}
