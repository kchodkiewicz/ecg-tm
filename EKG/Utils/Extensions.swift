//
//  Extentions.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 04/05/2021.
//

import SwiftUI
import UIKit

extension Color {
    static var background: Color {
            Color(UIColor { (traits) -> UIColor in
                if traits.userInterfaceStyle == .dark {
                    return UIColor.init(red: 50/255, green: 50/255, blue: 54/255, alpha: 1.0)
                } else {
                    return UIColor.init(red: 239/255, green: 239/255, blue: 240/255, alpha: 1.0)
                }
            })
        }
}

//TODO: add keyboard dismiss on drag
extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        tapGesture.name = "MyTapGesture"
        window.addGestureRecognizer(tapGesture)
    }
 }

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false // set to `false` if you don't want to detect tap during other gestures
    }
}


//extension View {
//    func animate(using animation: Animation = Animation.linear(duration: 0.1), _ action: @escaping () -> Void) -> some View {
//        onAppear {
//            withAnimation(animation) {
//                action()
//            }
//        }
//    }
//}
//
//extension View {
//    func animateForever(using animation: Animation = Animation.linear(duration: 0.1), autoreverses: Bool = false, _ action: @escaping () -> Void) -> some View {
//        let repeated = animation.repeatForever(autoreverses: autoreverses)
//        return onAppear {
//            withAnimation(repeated) {
//                action()
//            }
//        }
//    }
//}

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
                .clipShape(configuration.isPressed ? Circle() : Circle())
        }
    }
}
