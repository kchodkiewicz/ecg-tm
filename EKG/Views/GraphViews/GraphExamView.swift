//
//  GraphExamView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 09/03/2021.
//

import SwiftUI
import CoreData

struct RoundButtonStyle: ButtonStyle {
    
    let foregroundColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        ZStack {
            Circle()
                .fill(configuration.isPressed ? Color.clear : foregroundColor)
                .frame(width: 55, height: 55)
                .padding(10)
            Circle()
                .stroke(foregroundColor, lineWidth: 3.0)
                .frame(width: 63, height: 63)
            
            configuration.label
                .frame(width: 63, height: 63)
                .foregroundColor(configuration.isPressed ? Color.secondary : Color.white)
                //.background(configuration.isPressed ? Color.white : Color.clear)
                .clipShape(configuration.isPressed ? Circle() : Circle())
        }
    }
}


struct GraphExamView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    let profile: Profile
    
    var body: some View {
        VStack {
            
            Spacer()
            
            GraphDetail(points: profile.examArray.last?.sampleArray ?? [])
            
            Spacer()
            
            HStack {
                
                Spacer()
                
                Button(action: {
                    // Stop examination
                    print("Stop button")
                }, label: {
                    Text("Stop")
                    
                })
                .buttonStyle(RoundButtonStyle(foregroundColor: Color(red: 185/255, green: 45/255, blue: 45/255)))
                
                Spacer()
                Spacer()
                
                Button(action: {
                    // Start examination
                    print("Start button")
                    
                    // FOR TESTING ONLY -----------
                    var samples: [Sample] = []
                    for i in 0...10 {
                        let sample = Sample(context: viewContext)
                        sample.id = UUID()
                        sample.xValue = Int64(i)
                        sample.yValue = Int64(Int.random(in: 0...200))
                        samples.append(sample)
                    }
                    
                    let exam = Exam(context: viewContext)
                    exam.id = UUID()
                    exam.date = Date()
                    exam.addToSample(NSSet(array: samples))
                    
                    let profile = self.profile
                    profile.addToExam(exam)
                    
                    try? self.viewContext.save()
                    // ---------------------------
                    
                }, label: {
                    Text("Start")
                })
                .buttonStyle(RoundButtonStyle(foregroundColor: Color(red: 45/255, green: 185/255, blue: 185/255)))
                
                Spacer()
            }
            
            Spacer()
            Spacer()
        }
        .navigationTitle("Examination")
    }
}


//struct GraphExamView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        GraphExamView(userData: Profile())
//    }
//}
