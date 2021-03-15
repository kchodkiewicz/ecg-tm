//
//  ProfileView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 10/03/2021.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Profile.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Profile.id, ascending: true)],
        animation: .default)
    private var profile: FetchedResults<Profile>
    
    @Environment(\.editMode) var mode
    @EnvironmentObject var activeSession: ActiveSession
    //@State var draftProfile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
                    
                    HStack {
                        
                        if self.mode?.wrappedValue == .active {
                            Button("Cancel") {
                                //self.draftProfile = self.userData.profile
                                self.mode?.animation().wrappedValue = .inactive
                            }
                        }
                        
                        Spacer()
                        
                        EditButton()
                    }
                    
                    if self.mode?.wrappedValue == .inactive {
                        ProfileSummaryView(filter: activeSession.username)
                    } else {
                        ProfileEditView()
                        .onAppear {
                            //self.draftProfile = self.userData.profile
                        }
                        .onDisappear {
                            //self.userData.profile = self.draftProfile
                        }
                    }
                    
                    
                }.padding()
        
        
    }
}

