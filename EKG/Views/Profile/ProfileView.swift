//
//  ProfileView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 10/03/2021.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    var profile: Profile

    @Environment(\.editMode) var mode
    @EnvironmentObject var activeSession: ActiveSession
    @State var draftProfile = ProfileTmp.default

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            HStack {

                if self.mode?.wrappedValue == .active {
                    Button("Cancel") {
                        
                        self.draftProfile = ProfileTmp(username: self.profile.wrappedUsername, firstName: self.profile.wrappedFirstName, lastName: self.profile.wrappedLastName, age: self.profile.age, examDuration: self.profile.examDuration)
                        
                        self.mode?.animation().wrappedValue = .inactive
                        
                    }
                }

                Spacer()

                EditButton()
            }

            if self.mode?.wrappedValue == .inactive {
                ProfileSummaryView(profile: self.activeSession.profile!)
            } else {
                ProfileEditView(profile: $draftProfile)
                .onAppear {
                    
                    self.draftProfile = ProfileTmp(username: self.profile.wrappedUsername, firstName: self.profile.wrappedFirstName, lastName: self.profile.wrappedLastName, age: self.profile.age, examDuration: self.profile.examDuration)
                    
                }
                .onDisappear {
                    
                    let profile = self.profile
                    profile.username = draftProfile.username
                    profile.firstName = draftProfile.firstName
                    profile.lastName = draftProfile.lastName
                    profile.age = draftProfile.age
                    profile.examDuration = draftProfile.examDuration

                    try? self.viewContext.save()
                    self.activeSession.profile = self.profile

                }
            }
        }.padding()
    }
}

