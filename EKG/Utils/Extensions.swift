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
        tapGesture.name = "MyTapGesture"
        window.addGestureRecognizer(tapGesture)
    }
 }

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false // set to `false` if you don't want to detect tap during other gestures
    }
}
