//
//  DeleteOverlay.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 27/04/2021.
//

import SwiftUI
import UIKit
import Combine

struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIVisualEffectView
    
    let style: UIBlurEffect.Style
    
    init(style: UIBlurEffect.Style = .systemMaterial) {
        self.style = style
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: self.style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: self.style)
    }
}

struct UserRemovalOverlay: View {
    
    var size: CGFloat
    
    var body: some View {
        Image(systemName: "minus")
            .font(.title)
            .padding()
            .background(BlurView(style: .systemUltraThinMaterial))
            .clipShape(Circle())
            
        
    }
}

struct DeleteOverlay_Previews: PreviewProvider {
    static var previews: some View {
        UserRemovalOverlay(size: 100)
    }
}
