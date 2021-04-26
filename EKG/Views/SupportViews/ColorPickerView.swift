//
//  ColorPickerView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 26/04/2021.
//

import SwiftUI

struct ColorPickerView: View {
    
    @Binding var profileColor: ProfileColor
    
    
    var body: some View {
        
        let columns = [
            GridItem(.adaptive(minimum: 60))
        ]

        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(ProfileColor.allCases, id: \.self){ color in
                ZStack {
                    Circle()
                        .fill(Color(color.rawValue))
                        .frame(width: 50, height: 50)
                        .onTapGesture(perform: {
                            profileColor = color
                        })
                        .padding(10)

                    if profileColor == color {
                        Circle()
                            .stroke(Color(color.rawValue), lineWidth: 5)
                            .frame(width: 60, height: 60)
                    }
                }
            }
        }
        .padding(10)
    }
}

//struct ColorPickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ColorPickerView()
//    }
//}
