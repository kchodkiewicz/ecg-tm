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


extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        tapGesture.name = "TapGesture"
        let dragGesture = UISwipeGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        dragGesture.cancelsTouchesInView = false
        dragGesture.direction = .down
        dragGesture.numberOfTouchesRequired = 1
        dragGesture.delegate = self
        dragGesture.name = "DragGesture"
        window.addGestureRecognizer(dragGesture)
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
            RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                .fill(configuration.isPressed ? Color.clear : foregroundColor)
                .frame(width: 220, height: 55)
                .padding(10)
            RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                .stroke(foregroundColor, lineWidth: 3.0)
                .frame(width: 228, height: 63)
            
            configuration.label
                .frame(width: 63, height: 63)
                .foregroundColor(configuration.isPressed ? Color.secondary : Color.white)
                .clipShape(configuration.isPressed ? Circle() : Circle())
        }
    }
}

struct ColoredGroupBoxStyle: GroupBoxStyle {
    var backgroundColor: UIColor = UIColor.systemGroupedBackground
    
    var labelColor: UIColor = UIColor.label
    var opacity: Double = 1
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            HStack {
                configuration.label
                    .font(Font.bold(.body)())
                    .foregroundColor(Color(labelColor))
                Spacer()
            }
            configuration.content
        }
        
        .padding()
        .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color(backgroundColor))
                        .opacity(opacity)
        )
    }
}

struct SharpGroupBoxStyle: GroupBoxStyle {
    var backgroundColor: UIColor = UIColor.systemGroupedBackground
    
    var labelColor: UIColor = UIColor.label
    var opacity: Double = 1
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            HStack {
                configuration.label
                    .font(Font.bold(.body)())
                    .foregroundColor(Color(labelColor))
                Spacer()
            }
            configuration.content
        }
        
        .padding()
        .background(Rectangle()
                        .fill(Color(backgroundColor))
                        .opacity(opacity)
        )
    }
}

struct CompressedLabelStyle: LabelStyle {

    var labelColor: UIColor = UIColor.label
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .lastTextBaseline, spacing: 1) {
            configuration.icon
                .font(Font.system(.title3, design: .rounded).bold())
                .foregroundColor(Color(labelColor))
            configuration.title
                .font(Font.system(.title3, design: .rounded).bold())
                .foregroundColor(Color(labelColor))
        }
        
    }
}


