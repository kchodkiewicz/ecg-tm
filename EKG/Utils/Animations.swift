//
//  Animations.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 26/04/2021.
//

import Foundation
import SwiftUI

extension AnyTransition {

    static public var sectionSlide: AnyTransition {
        let insertion = AnyTransition.move(edge: .bottom)
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .top)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    static public var logoMove: AnyTransition {
        let insertion = AnyTransition.move(edge: .bottom)
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .top)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
}
