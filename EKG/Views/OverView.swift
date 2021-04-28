//
//  OverView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 13/03/2021.
//

import SwiftUI
import CoreBluetooth

struct OverView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var activeSession: ActiveSession
    
    @ObservedObject var bleConnection = BLEConnection()
    
    var profile: Profile
    
    @State private var showingNewExam: Bool = false
    @State private var showingProfile: Bool = false
    @State private var showingBTScan: Bool = false
    
    
    private func connectBLEDevice() {
        
        // Start Scanning for BLE Devices
        bleConnection.startCentralManager()
        
        //TODO: try connecting to saved device (CoreData: Profile.btRRSI <- add)
        
    }
    
    var body: some View {
        
        TabView {
            // History
            NavigationView {
                HistoryView(filter: profile.username!)
                    
            }.tabItem {
                Image(systemName: "house.circle")
                    .imageScale(.large)
                    .accessibility(label: Text("History"))
                Text("History")
            }.tag(Tab.history)
            
            // Exam
            NavigationView {
                GraphExamView(profile: self.profile)
            }.tabItem {
                Image(systemName: "waveform.path.ecg.rectangle.fill")
                    .imageScale(.large)
                    .accessibility(label: Text("New Examination"))
                Text("Exam")
            }
            .tag(Tab.exam)
            // Profile
            NavigationView {
                ProfileEditView(
                    viewContext: viewContext,
                    profile: self.profile,
                    username: self.profile.wrappedUsername,
                    firstName: self.profile.wrappedFirstName,
                    lastName: self.profile.wrappedLastName,
                    age: self.profile.wrappedAge,
                    examDuration: Int(self.profile.examDuration),
                profileColor: ProfileColor.ColorName(value: self.profile.wrappedColor))
                
            }.tabItem {
                Image(systemName: "person.crop.circle")
                    .imageScale(.large)
                    .accessibility(label: Text("User Profile"))
                    .padding()
                Text("Profile")
            }.tag(Tab.profile)
            
            
        }
        .onAppear(perform: connectBLEDevice)
        
    }
}

//struct OverView_Previews: PreviewProvider {
//    static var previews: some View {
//        OverView()
//    }
//}
