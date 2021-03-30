//
//  ProfileEditView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 11/03/2021.
//
import SwiftUI

struct ProfileEditView: View {
    
    @Binding var profile: ProfileTmp
    
    var body: some View {
        Form {
            Section {
                TextField("Username", text: $profile.username)
            }
            Section {
                TextField("First Name", text: $profile.firstName)
                TextField("Last Name", text: $profile.lastName)
                TextField("Age", text: $profile.age)
                    .keyboardType(.decimalPad)
            }
            Section {
                Stepper("\(profile.examDuration) seconds", value: $profile.examDuration, in: 1...60)
            }
        }
    }
}

//struct ProfileEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileEditView()
//    }
//}
