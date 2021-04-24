//
//  GraphExamView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 09/03/2021.
//

import SwiftUI

struct RoundButtonStyle: ButtonStyle {
    
    let foregroundColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        ZStack {
            Circle()
                .stroke(foregroundColor, lineWidth: 4.0)
                .frame(width: 60, height: 60)
            Circle()
                .stroke(foregroundColor, lineWidth: 2.0)
                .frame(width: 68, height: 68)
            
            configuration.label
            .frame(width: 60, height: 60)
            .foregroundColor(configuration.isPressed ? .white : foregroundColor)
            .background(configuration.isPressed ? foregroundColor : Color.white)
            .clipShape(configuration.isPressed ? Circle() : Circle()
            )
        }
    }
}


struct GraphExamView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    let profile: Profile
    let points: [Sample]
    
    var body: some View {
        VStack {

            Spacer()

            GraphDetail(points: points)

            Spacer()

            HStack {

                Spacer()

                Button(action: {
                    // Start examination
                    print("Stop button")
                }, label: {
                    Text("Stop")

                })
                .buttonStyle(RoundButtonStyle(foregroundColor: Color(red: 215/255, green: 0/255, blue: 21/255)))


                Spacer()
                Spacer()

                Button(action: {
                    // Stop examination
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
                .buttonStyle(RoundButtonStyle(foregroundColor: Color(red: 36/255, green: 138/255, blue: 61/255)))

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
