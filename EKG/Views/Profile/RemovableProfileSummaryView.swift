//
//  ProfileSummaryView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 15/03/2021.
//

import SwiftUI

struct ProfileSummaryView: View {
    
    var profile: Profile
    
    var body: some View {
        List {
            Text("\(self.profile.wrappedFirstName) \(self.profile.wrappedLastName)")
                .bold()
                .font(.title)
            
            // TODO add notification toggle
            Text("First Name: \(self.profile.wrappedFirstName)")
            Text("Last Name: \(self.profile.wrappedLastName)")
            Text("Age: \(self.profile.age)")
            Text("Exam Duration: \(Int(self.profile.examDuration))")
            
        }
    }
}

//struct ProfileSummaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileSummaryView()
//    }
//}
