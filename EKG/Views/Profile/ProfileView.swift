//
//  ProfileView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 10/03/2021.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(
//        entity: Profile.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \Profile.id, ascending: true)],
//        animation: .default)
//    private var profile: FetchedResults<Profile>
    
    @Environment(\.editMode) var mode
    @EnvironmentObject var activeSession: ActiveSession
    @State var draftProfile = Profile()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
                    
            HStack {
                
                if self.mode?.wrappedValue == .active {
                    Button("Cancel") {
                        self.draftProfile = self.activeSession.profile!
                        self.mode?.animation().wrappedValue = .inactive
                    }
                }
                
                Spacer()
                
                EditButton()
            }
            
            if self.mode?.wrappedValue == .inactive {
                ProfileSummaryView(profile: self.activeSession.profile!)
            } else {
                ProfileEditView(filter: activeSession.username)
                .onAppear {
                    self.draftProfile = self.activeSession.profile!
                }
                .onDisappear {
                    self.activeSession.profile = self.draftProfile
                }
            }
        }.padding()
    }
    
    
}

