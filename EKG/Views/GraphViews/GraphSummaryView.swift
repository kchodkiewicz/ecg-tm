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
    
    var resultImage: some View {
        
        switch exam.resultName {
        case .good:
            return Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
        case .alerting:
            return Image(systemName: "minus.circle.fill").foregroundColor(.yellow)
        case .bad:
            return Image(systemName: "multiply.circle.fill").foregroundColor(.orange)
        case .critical:
            return Image(systemName: "cross.circle.fill").foregroundColor(.red)
        }
        
    }
    
    private func getResult(preResult: ExamResult) -> ExamResult {
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
            return preResult
        }
        
        for index in 1..<peaksConverted.count {
            let lhs = peaksConverted[index]
            let rhs = peaksConverted[index - 1]
            times.append(abs(lhs - rhs))
        }
        
        let iqr = times.sorted()[Int(Double(times.count) * 0.75)] - times.sorted()[Int(Double(times.count) * 0.25)]
        
        let distanceIQR = abs(iqr - 0.06)
        
        var result = preResult
        
        if distanceIQR > 0.03 {
            result = preResult.next()
        }
        if distanceIQR > 0.05 {
            result = preResult.next()
        }
        if distanceIQR > 0.08 {
            result = preResult.next()
        }
        
        return result
        
    }
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            
            GroupBox(
                label: Label("Electrocardiogram", systemImage: "waveform.path.ecg")
                        .foregroundColor(Color(UIColor.systemPurple))
            ) {
                GraphDetail(points: exam.sampleArray)
                    .frame(minHeight: 300.0)
            }.groupBoxStyle(SharpGroupBoxStyle(backgroundColor: .secondarySystemGroupedBackground))
            
            
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
                }.padding(.init(top: 10, leading: 10, bottom: 5, trailing: 5))
                
                GroupBox(
                    label: Label("Result", systemImage: "heart.text.square.fill")
                        .foregroundColor(Color(UIColor.systemTeal))
                ) {
                    HStack(alignment: .lastTextBaseline, spacing: 0) {
//                        resultImage
//                            .font(.system(.largeTitle, design: .rounded))
                        Text("\(getResult(preResult: exam.resultName).rawValue)")
                            .font(.system(.largeTitle, design: .rounded))
                            .bold()
                            //.foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }.padding(.init(top: 10, leading: 5, bottom: 5, trailing: 10))
                
                }
            
            
            
            
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
                    
                }.padding(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
                
                
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
                }.padding(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
                
            }
//            .padding(.horizontal)
//            .padding(.bottom)
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
            
            let exam = self.exam
            exam.type = self.examType.rawValue
            exam.notes = self.notes
            
            try? self.viewContext.save()
        }
    }
    
}
