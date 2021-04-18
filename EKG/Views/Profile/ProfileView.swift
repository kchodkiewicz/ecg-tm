//
//  ProfileView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 10/03/2021.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(\.managedObjectContext) var viewContext
//    @FetchRequest(
//        entity: Profile.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \Profile.username, ascending: true)],
//        animation: .default)
//    private var profile: FetchedResults<Profile>
    
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
//                    self.draftProfile = ProfileTmp(username: profile.wrappedUsername, firstName: profile.wrappedFirstName, lastName: profile.lastName, age: profile.age, examDuration: profile.examDuration)
                }
                .onDisappear {
                    let profile = self.profile
                    profile.username = draftProfile.username
                    profile.firstName = draftProfile.firstName
                    profile.lastName = draftProfile.lastName
                    // TODO verify if numbers
                    profile.age = Int64(draftProfile.age)
                    profile.examDuration = Float(draftProfile.examDuration)

                    try? self.viewContext.save()

                }
            }
        }.padding()
    }

//    init() {
//        self.draftProfile = ProfileTmp(
//            username: self.activeSession.profile?.wrappedUsername ?? ProfileTmp.default.username,
//            firstName: self.activeSession.profile?.wrappedFirstName ?? ProfileTmp.default.firstName,
//            lastName: self.activeSession.profile?.wrappedLastName ?? ProfileTmp.default.lastName,
//            age: String(self.activeSession.profile?.age ?? 0),
//            examDuration: Float(self.activeSession.profile?.examDuration ?? 5)
//        )
//    }
    
}

