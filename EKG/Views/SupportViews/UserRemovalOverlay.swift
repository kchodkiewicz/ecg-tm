//
//  DeleteOverlay.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 27/04/2021.
//

import SwiftUI

struct UserRemovalOverlay: View {
    
    var size: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.black)
                .opacity(0.5)
                .frame(width: size, height: size, alignment: .center)
                .animation(.spring())
            
            //TODO: Beautify userRemoval X marker
            RoundedRectangle(cornerRadius: 5.0)
                .foregroundColor(.white)
                .frame(width: size * 0.1, height: size * 0.8, alignment: .center)
                .rotationEffect(.degrees(45.0))
            
            RoundedRectangle(cornerRadius: 5.0)
                .foregroundColor(.white)
                .frame(width: size * 0.1, height: size * 0.8, alignment: .center)
                .rotationEffect(.degrees(-45.0))
        }
    }
}
//
//struct DeleteOverlay_Previews: PreviewProvider {
//    static var previews: some View {
//        UserRemovalOverlay()
//    }
//}
