//
//  GraphView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 09/03/2021.
//

import SwiftUI


struct GraphSummaryView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    var exam: Exam
    @State var notes: String = ""
    @State var examType: ExamType = .resting
    
    //TODO: remove cause its only for testing
    private func calcHeartRate() -> (Int64, [Double]) {
        // peak if value greater than both neighbours and value
        // greater than 0.6
        let samples = self.exam.sampleArray
        var peaks: [Double] = []
        
        guard samples.count - 1 > 1 else {
            return (-1, [])
        }
        for index in 1 ..< samples.count - 1 {
            if (samples[index] > samples[index + 1] && samples[index] > samples[index - 1]) && samples[index].yValue >= 0.6 {
                peaks.append(samples[index].xValue)
            }
        }
        
        let duration = samples.count / 250
        guard duration != 0 else {
            return (-1, [])
        }
        let rate = Int64(Double(peaks.count) / Double(duration) * 60.0) // for bpm
        
        // return peaks
        return (rate, peaks)
    }
    
    var resultImage: some View {
        
        switch exam.resultName {
        case .good:
            return Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
        case .nominal:
            return Image(systemName: "minus.circle.fill").foregroundColor(.yellow)
        case .bad:
            return Image(systemName: "multiply.circle.fill").foregroundColor(.orange)
        case .critical:
            return Image(systemName: "cross.circle.fill").foregroundColor(.red)
        }
        
    }
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            
            GroupBox(
                label: Label("Electrocardiogram", systemImage: "waveform.path.ecg")
                        .foregroundColor(Color(UIColor.systemPurple))
            ) {
                GraphDetail(points: exam.sampleArray)
                    .frame(minHeight: 300.0)
            }
            
            
            Spacer()
            
            VStack {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                
                GroupBox(
                    label: Label("Heart Rate", systemImage: "heart.fill")
                        .foregroundColor(Color(UIColor.systemPink))
                ) {
                    HStack(alignment: .lastTextBaseline, spacing: 0) {
                        Text("\(exam.heartRate)")
                            .font(.system(.largeTitle, design: .rounded))
                            .bold()
                        Text("BPM")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox(
                    label: Label("Result", systemImage: "heart.text.square.fill")
                        .foregroundColor(Color(UIColor.systemTeal))
                ) {
                    HStack(alignment: .lastTextBaseline, spacing: 0) {
                        resultImage
                            .font(.system(.largeTitle, design: .rounded))
                        Text("\(exam.resultName.rawValue)")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                
            }.padding(.horizontal)
            .padding(.top)
            
            
            
            LazyVGrid(columns: [GridItem(.flexible())]) {
                
                PeaksGroupBox(exam: self.exam)
                    
                
                GroupBox(
                    label: Label("Exam type", systemImage: "lungs.fill")
                        .foregroundColor(Color(UIColor.systemIndigo))
                ) {
                    
                    Picker("Exam type", selection: $examType) {
                        ForEach(ExamType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                            
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                }
                
                
                GroupBox(
                    label: Label("Notes", systemImage: "note.text")
                        .foregroundColor(Color(UIColor.systemOrange))
                    
                ) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 200)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .onAppear(perform: {
                            UITextView.appearance().backgroundColor = .clear
                            //UITextView.appearance().keyboardDismissMode = .interactive
                        })
                }
                
            }
            .padding(.horizontal)
            .padding(.bottom)
            }//.background(Color(UIColor.systemGroupedBackground))
            
        
        }
        .groupBoxStyle(ColoredGroupBoxStyle(backgroundColor: UIColor.secondarySystemGroupedBackground))
        .navigationTitle(Text(exam.wrappedDate, formatter: Formatters.titleDateFormat))
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .onDisappear(perform: updateExam)
    }
    
    func updateExam() {
        withAnimation {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            
            //TODO: remove cause it only for testing
            // --------- tests
            let stats = calcHeartRate()
            var peaks: [Peaks] = []
            for index in 0..<stats.1.count {
                let peak = Peaks(context: viewContext)
                peak.id = UUID()
                peak.peakNo = Double(index)
                peak.xValue = stats.1[index]
                peaks.append(peak)
            }
            // ---------
            
            let exam = self.exam
            exam.type = self.examType.rawValue
            exam.notes = self.notes
            
            // --------- tests
            exam.heartRate = stats.0
            exam.addToPeaks(NSSet(array: peaks))
            // ---------
            
            try? self.viewContext.save()
        }
    }
    
}
