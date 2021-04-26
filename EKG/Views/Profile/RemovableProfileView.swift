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
    
   
    
    var profile: Profile
    
    @ObservedObject var bleConnection = BLEConnection()
    @Environment(\.editMode) var mode
    
    @EnvironmentObject var activeSession: ActiveSession
    
    @State var showingEditMode: Bool = false
    
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("First Name:")
                    Spacer()
                    Text("\(self.profile.wrappedFirstName)")
                }
                HStack {
                    Text("Last Name:")
                    Spacer()
                    Text("\(self.profile.wrappedLastName)")
                }
                HStack {
                    Text("Age:")
                    Spacer()
                    //Text("\(self.profile.age ?? "s")")
                }
                HStack {
                    Text("Exam Duration:")
                    Spacer()
                    Text("\(Int(self.profile.examDuration))")
                }
            }
            Section {
                
                NavigationLink(destination: BTView(bleConnection: bleConnection)) {
                    Text("Bluetooth Device")
                    Spacer()
                    
                    Text(bleConnection.peripheral?.name ?? "None")
                }
                
            }
            Section {
                
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        self.activeSession.profile = nil
                    }
                } label: {
                    Text("Switch User")
                }
                
            }
        }
        
        
        .navigationBarItems(trailing: Button(action: {
            withAnimation(.spring()) {
                self.showingEditMode.toggle()
            }
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
                //age: self.profile.age,
                examDuration: Int(self.profile.examDuration))
        }
        
        .navigationBarTitle(
            Text("\(self.profile.username ?? "Profile")")
        )
        
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

