//
//  RecentExamOverlay.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 23/05/2021.
//

import SwiftUI

struct RecentExamOverlay: View {
    var body: some View {
        Rectangle()
            .blur(radius: 100.0, opaque: false)
            .opacity(0.7)
    }
}

struct RecentExamOverlay_Previews: PreviewProvider {
    static var previews: some View {
        RecentExamOverlay()
    }
}
