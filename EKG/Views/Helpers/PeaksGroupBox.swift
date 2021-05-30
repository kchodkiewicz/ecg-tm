//
//  PeaksGroupBox.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 28/05/2021.
//
import SwiftUI

struct CardioStats {
    var meanTime: Double = 0.0
    var variation: Double = 0.0
    var times: [Double] = []
    
}

struct PeaksGroupBox: View {
    
    var exam: Exam
    @State var isShowingGraph: Bool = false
    
    var stats: CardioStats
    
    func getStats() -> CardioStats {
        var stats = CardioStats()
        var times: [Double] = []
        guard exam.peaksArray.count > 1 else {
            return stats
        }
        for index in 1..<exam.peaksArray.count {
            times.append(exam.peaksArray[index] - exam.peaksArray[index - 1])
        }
        
        var sum: Double {
            var sum: Double = 0
            for t in times {
                sum += t
            }
            return sum
        }
        
        stats.meanTime = sum / Double(times.count)
        stats.variation = times.sorted().last! - times.sorted().first!
        stats.times = times
        return stats
    }
    
    
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
                            Text("Variability")
                                .font(.system(.headline, design: .rounded))
                                .bold()
                                .foregroundColor(Color(.systemBlue))
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
                    }
                    
                    
                }
            }
            .buttonStyle(PlainButtonStyle())
            
        }
    }
    
    init(exam: Exam) {
        self.exam = exam
        self.stats = CardioStats()
        let stats = getStats()
        self.stats.meanTime = stats.meanTime
        self.stats.times = stats.times
        self.stats.variation = stats.variation
        
    }
}

//struct PeaksGroupBox_Previews: PreviewProvider {
//    static var previews: some View {
//        PeaksGroupBox()
//    }
//}
