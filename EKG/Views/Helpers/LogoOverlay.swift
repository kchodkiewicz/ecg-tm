//
//  LogoOverlay.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 23/05/2021.
//

import SwiftUI


struct LogoOverlay: View {
    
    var isOverlaying: Bool
    
    var body: some View {
        Circle()
            .fill(LinearGradient(gradient: Gradient(colors: [Color.black, Color.clear]), startPoint: .bottom, endPoint: .top))
            .opacity(self.isOverlaying ? 0.7 : 0.0)
    }
}

struct LogoOverlay_Previews: PreviewProvider {
    static var previews: some View {
        LogoOverlay(isOverlaying: true)
    }
}
