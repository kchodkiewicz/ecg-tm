//
//  ProfileView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 10/03/2021.
//


import SwiftUI
import CoreData

struct ProfileView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
        entity: Profile.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Profile.username, ascending: true)],
        animation: .default)
    private var profiles: FetchedResults<Profile>

    var profile: Profile
    
    @ObservedObject var bleConnection = BLEConnection()
    @Environment(\.editMode) var mode
    
    @EnvironmentObject var activeSession: ActiveSession
    @State var draftProfile = Profile()
    @State var showingEditMode: Bool = false
    @State var showingBTConfig: Bool = false

    var body: some View {
        
        NavigationView {
            
            List {
//                Text("\(self.profile.wrappedFirstName) \(self.profile.wrappedLastName)")
//                    .bold()
//                    .font(.title)
                
                // TODO add notification toggle
                Text("First Name: \(self.profile.wrappedFirstName)")
                Text("Last Name: \(self.profile.wrappedLastName)")
                Text("Age: \(self.profile.age)")
                Text("Exam Duration: \(Int(self.profile.examDuration))")
                
                Button {
                    self.showingBTConfig.toggle()
                } label: {
                    Text("Bluetooth Configuration")
                }.sheet(isPresented: $showingBTConfig) {
                    BTView(bleConnection: bleConnection)
                }

                
            }
            
                .navigationBarItems(trailing: Button(action: {
                    self.showingEditMode.toggle()
                }, label: {
                    Text("Edit")
                }))
                .sheet(isPresented: $showingEditMode) {
                    ProfileEditView(
                        viewContext: viewContext,
                        profile: self.profile,
                        username: self.profile.username ?? "",
                        firstName: self.profile.firstName ?? "",
                        lastName: self.profile.lastName ?? "",
                        age: self.profile.age,
                        examDuration: self.profile.examDuration)
                }
            .navigationBarTitle("\(self.profile.username ?? "Profile")")
            
        }
//        VStack(alignment: .leading, spacing: 20) {

//            HStack {
//
//                if self.mode?.wrappedValue == .active {
//                    Button("Cancel") {
//
//                       self.draftProfile = self.profile
//
//                        self.mode?.animation().wrappedValue = .inactive
//
//                    }
//                }
//
//                Spacer()
//
//                EditButton()
//            }
            
            
//
//            if self.mode?.wrappedValue == .inactive {
//
//            } else {
//                ProfileEditView(
//                    viewContext: viewContext,
//                    profile: self.profile)
//                    username: self.profile.username,
//                    firstName: self.profile.firstName,
//                    lastName: self.profile.lastName,
//                    age: self.profile.age,
//                    examDuration: self.profile.examDuration)
//                .onAppear {

//                    self.draftProfile = self.profile

//                }
//                .onDisappear {

//                    self.activeSession.profile = self.profile
//
//                }
//            }
//        }.padding()
    }
}

