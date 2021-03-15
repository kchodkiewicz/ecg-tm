//
//  ProfileView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 10/03/2021.
//

import SwiftUI

struct ProfileView: View {
    
    var profile: Profile
    
    var body: some View {
        List {
            Text("\(self.profile.firstName!) \(self.profile.lastName!)")
                .bold()
                .font(.title)
            // TODO add notification toggle
            
            Text("First Name: \(self.profile.firstName ?? "-")")
            Text("Last Name: \(self.profile.lastName ?? "-")")
            Text("Age: \(self.profile.age ?? 0)")
            Text("Exam Duration: \(self.profile.examDuration ?? 0)")
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profile: Profile())
    }
}
