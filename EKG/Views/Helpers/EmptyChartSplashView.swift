//
//  EmptyChartSplashView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 24/05/2021.
//

import SwiftUI
import Foundation

struct EmptyChartSplashView: View {
    
    @State var countdown: Int = 6
    @Binding var triggerCountdown: Bool

    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(self.countdown > 5 || self.countdown < 1 ? "" : String(self.countdown))
            .onReceive(timer, perform: { _ in
                
                if self.countdown > 0 && self.triggerCountdown {
                    self.countdown -= 1
                    if self.countdown < 1 {
                        self.countdown = 6
                        self.triggerCountdown.toggle()
                    }
                }
            })
            .padding()
            .transition(.placeholderFade)
            .animation(.easeInOut)
    }
}

//struct EmptyChartSplashView_Previews: PreviewProvider {
//    @State var trigger = true
//    static var previews: some View {
//        EmptyChartSplashView()
//    }
//}
