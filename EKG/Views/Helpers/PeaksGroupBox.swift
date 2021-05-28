//
//  PeaksGroupBox.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 28/05/2021.
//
import SwiftUI

struct PeaksGroupBox: View {
    
    var exam: Exam
    @State var isShowingGraph: Bool = false
    
    func getMeanTime() -> Double {
        var times: [Double] = []
        guard exam.peaksArray.count > 1 else {
            return 0.0
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
        
        return sum / Double(times.count)
    }
    
    var body: some View {
        if !exam.peaksArray.isEmpty {
        GroupBox(label:
            Label("Rhythm", systemImage: "metronome.fill")
                .foregroundColor(Color(UIColor.systemPink))
        ) {
            Button {
                withAnimation {
                    self.isShowingGraph.toggle()
                }
            } label: {
                if self.isShowingGraph {
                    MeanGraph(points: exam.peaksArray)
                } else {
                    Text("\(getMeanTime())")
                        .font(.system(.largeTitle, design: .rounded))
                        .bold()
                    Text("BPM")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.secondary)
                }
            }.buttonStyle(PlainButtonStyle())

            
        }
        }
        
    }
}

//struct PeaksGroupBox_Previews: PreviewProvider {
//    static var previews: some View {
//        PeaksGroupBox()
//    }
//}
