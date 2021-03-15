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
    
    let userData: Profile
    
    var body: some View {
//        VStack {
//
//            Spacer()
//
//            GraphDetail(points: userData.exams[0].dataPoints)
//
//            Spacer()
//
//            HStack {
//
//                Spacer()
//
//                Button(action: {
//                    // Start examination
//                    print("Stop button")
//                }, label: {
//                    Text("Stop")
//
//                })
//                .buttonStyle(RoundButtonStyle(foregroundColor: Color(red: 215/255, green: 0/255, blue: 21/255)))
//
//
//                Spacer()
//                Spacer()
//
//                Button(action: {
//                    // Stop examination
//                    print("Start button")
//                }, label: {
//                    Text("Start")
//                })
//                .buttonStyle(RoundButtonStyle(foregroundColor: Color(red: 36/255, green: 138/255, blue: 61/255)))
//
//                Spacer()
//
//            }
//
//            Spacer()
//            Spacer()
//
//        }
//        .navigationTitle("Examination")
        Text("Exam")
    }

}


struct GraphExamView_Previews: PreviewProvider {
    static var previews: some View {
        
        GraphExamView(userData: Profile())
    }
}
