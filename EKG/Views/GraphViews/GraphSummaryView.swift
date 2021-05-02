//
//  GraphView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 09/03/2021.
//

import SwiftUI

struct GraphSummaryView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.editMode) var editMode
    
    let exam: Exam
    @State var notes: String = ""
    @State var heartRate: Int = 0
    @State var examType: ExamType = .resting
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            GraphDetail(points: exam.sampleArray)
            
          
            //TODO: rethink layout / UI
            Form {
                
                Section {
                    //FIXME: Type not saved to coredata
                    if self.editMode?.wrappedValue == .inactive {
                        HStack {
                            Text("Exam type")
                            Spacer()
                            Text(examType.rawValue)
                                .multilineTextAlignment(.trailing)
                        }
                    } else {
                        Picker("Exam type", selection: $examType) {
                            ForEach(ExamType.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        
                    }
                }
                
                Section {
                    //FIXME: Make keyboard disappear after top-bottom drag
                    MultilineTextField(placeholder: "Notes", text: $notes)
                        .frame(height: 200)
                        .disabled(.inactive == self.editMode?.wrappedValue)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                }
            }
            
        }
        
        .navigationBarItems(
            trailing: Button(action: {
                withAnimation(.spring()) {
                    self.editMode?.wrappedValue = .active == self.editMode?.wrappedValue ? .inactive : .active
                    updateExam()
                }
            }) {
                Text(.active == self.editMode?.wrappedValue ? "Done" : "Edit")
            }
            .padding(.vertical)
            .padding(.leading)
        )
        
        .navigationTitle(.inactive == self.editMode?.wrappedValue ? Text(exam.wrappedDate, formatter: Formatters.titleDateFormat) : Text("Edit examination"))
        
        
    }
    
    func updateExam() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        let exam = self.exam
        exam.type = self.examType.rawValue
        exam.notes = self.notes
        
        try? self.viewContext.save()
    }
    
}

// TextFiled for multi line supported.
struct MultilineTextField: UIViewRepresentable {
    var placeholder: String
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.delegate = context.coordinator
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.font = UIFont.systemFont(ofSize: 18)
        view.textColor = text.isEmpty ? UIColor(.secondary) : UIColor(.primary)
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.textColor = text.isEmpty ? UIColor(.secondary) : UIColor(.primary)
        guard !text.isEmpty else {
            uiView.text = placeholder
            return
        }
        if uiView.text != text {
            uiView.text = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator : NSObject, UITextViewDelegate {

        var parent: MultilineTextField

        init(_ textView: MultilineTextField) {
            self.parent = textView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }
}

