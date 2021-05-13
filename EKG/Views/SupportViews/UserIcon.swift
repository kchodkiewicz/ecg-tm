//
//  UserIcon.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 26/04/2021.
//

import SwiftUI

struct UserIcon: View {
    
    @Binding var isShowingPallette: Bool
    @Binding var profileColor: ProfileColor
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                withAnimation {
                    self.isShowingPallette.toggle()
                }
            } label: {
                
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100, alignment: .center)
                    .foregroundColor(Color(profileColor.rawValue))
                    
                
            }.frame(width: 100, height: 100, alignment: .center)
            .buttonStyle(PlainButtonStyle())
            Spacer()
        }.padding()
        if self.isShowingPallette {
            
            ColorPickerView(profileColor: self.$profileColor)
                .transition(.scale)
        }
    }
}

