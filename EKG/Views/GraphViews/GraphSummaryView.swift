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
                        .foregroundColor(Color(UIColor.systemGreen))
            ) {
                GraphDetail(points: exam.sampleArray)
                    .frame(minHeight: 300.0)
            }
            
            
            Spacer()
            
            VStack {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                
                GroupBox(
                    label: Label("Heart Rate", systemImage: "heart.fill")
                        .foregroundColor(Color(UIColor.systemRed))
                ) {
                    Text("\(exam.heartRate) BPM")
                        .font(.largeTitle)
                        .bold()
                }
                
                GroupBox(
                    label: Label("Result", systemImage: "heart.text.square.fill")
                        .foregroundColor(Color(UIColor.systemTeal))
                ) {
                    HStack {
                        resultImage
                            .font(.largeTitle)
                        
                        Text("\(exam.resultName.rawValue)")
                            .font(.largeTitle)
                            .bold()
                            .lineLimit(1)
                    }
                }
                
            }.padding(.horizontal)
            .padding(.top)
            
            
            
            LazyVGrid(columns: [GridItem(.flexible())]) {
                
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
            }.background(Color(UIColor.systemGroupedBackground))
            
        }
        .groupBoxStyle(ColoredGroupBoxStyle(backgroundColor: UIColor.secondarySystemGroupedBackground))
        .navigationTitle(Text(exam.wrappedDate, formatter: Formatters.titleDateFormat))
        //.background(Color(UIColor.systemGroupedBackground))
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
