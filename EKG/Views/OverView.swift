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
    
    //    @FetchRequest(
    //        entity: Profile.entity(),
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Profile.id, ascending: true)],
    //        animation: .default)
    //    private var profile: FetchedResults<Profile>
    
    var profile: Profile
    
    @State private var showingNewExam: Bool = false
    @State private var showingProfile: Bool = false
    @State private var showingBTScan: Bool = false
    
    
    private func connectBLEDevice() {
        
        // Start Scanning for BLE Devices
        bleConnection.startCentralManager()
        
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
            }
            
            // Exam
            NavigationView {
                GraphExamView(profile: self.profile)
            }.tabItem {
                Image(systemName: "waveform.path.ecg.rectangle.fill")
                    .imageScale(.large)
                    .accessibility(label: Text("New Examination"))
                Text("Exam")
            }
            
            // Profile
            NavigationView {
                ProfileEditView(
                    viewContext: viewContext,
                    profile: self.profile,
                    username: self.profile.username ?? "",
                    firstName: self.profile.firstName ?? "",
                    lastName: self.profile.lastName ?? "",
                    age: self.profile.age ?? Date(),
                    examDuration: Int(self.profile.examDuration))
                    .environmentObject(self.activeSession)
                
            }.tabItem {
                Image(systemName: "person.crop.circle")
                    .imageScale(.large)
                    .accessibility(label: Text("User Profile"))
                    .padding()
                Text("Profile")
            }
            
            
        }
        .onAppear(perform: connectBLEDevice)
        
    }
}

//struct OverView_Previews: PreviewProvider {
//    static var previews: some View {
//        OverView()
//    }
//}
