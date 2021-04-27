//
//  DeleteOverlay.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 27/04/2021.
//

import SwiftUI

struct UserRemovalOverlay: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.black)
                .opacity(0.5)
                .frame(width: 100, height: 100, alignment: .center)
                .animation(.spring())
            
            // Beautify
            RoundedRectangle(cornerRadius: 5.0)
                .foregroundColor(.white)
                .frame(width: 10, height: 80, alignment: .center)
                .rotationEffect(.degrees(45.0))
            
            RoundedRectangle(cornerRadius: 5.0)
                .foregroundColor(.white)
                .frame(width: 10, height: 80, alignment: .center)
                .rotationEffect(.degrees(-45.0))
        }
    }
}

struct DeleteOverlay_Previews: PreviewProvider {
    static var previews: some View {
        UserRemovalOverlay()
    }
}
