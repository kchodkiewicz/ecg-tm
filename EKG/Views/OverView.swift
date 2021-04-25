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
//
//        NavigationView {
            
            TabView {
                HistoryView(filter: profile.username!)
                    .tabItem{
                    Image(systemName: "house.circle")
                        .imageScale(.large)
                        .accessibility(label: Text("History"))
                        
                    Text("History")
                    }
                
                ProfileView(profile: self.profile)
                    .environmentObject(self.activeSession)
                    .tabItem{
                        Image(systemName: "person.crop.circle")
                                .imageScale(.large)
                                .accessibility(label: Text("User Profile"))
                                .padding()
                        Text("Profile")
                    }
                
                GraphExamView(profile: self.profile)
                    .tabItem {
                        Image(systemName: "waveform.path.ecg.rectangle.fill")
                            .imageScale(.large)
                            .accessibility(label: Text("New Examination"))
                        Text("Exam")
                    }
                
                
            }
            .onAppear(perform: connectBLEDevice)
            
            
//                .toolbar {
//                    // Top Toolbar
//
//
//                    ToolbarItem(placement: .primaryAction) {
//
//                        NavigationLink(
//                            destination: ProfileView(profile: self.profile).environmentObject(self.activeSession)) {
//                            Image(systemName: "person.crop.circle")
//                                .imageScale(.large)
//                                .accessibility(label: Text("User Profile"))
//                                .padding()
//                        }
//
////                            Button(action: {self.showingProfile.toggle()}) {
////                            Image(systemName: "person.crop.circle")
////                                .imageScale(.large)
////                                .accessibility(label: Text("User Profile"))
////                                .padding()
////                            }.sheet(isPresented: $showingProfile) {
////
////                                ProfileView()
////                                    .environmentObject(self.activeSession)
////
////                            }
//
//                    }
//
//                    ToolbarItem(placement: .primaryAction) {
//
//                        Button(action: {self.showingBTScan.toggle()}) {
//                            Image(systemName: "antenna.radiowaves.left.and.right")
//                            .imageScale(.large)
//                            .accessibility(label: Text("Bluetooth connection"))
//                            .padding()
//                        }.sheet(isPresented: $showingBTScan) {
//
//                            BTView(bleConnection: bleConnection)
//
//                        }
//
//                    }
//
//                    ToolbarItem(placement: .bottomBar) {
//
//                        // Bottom Toolbar
//                        Button(action: {
//                            self.showingNewExam.toggle()
//                        }) {
//                            Image(systemName: "waveform.path.ecg.rectangle.fill")
//                                .imageScale(.large)
//                                .accessibility(label: Text("New Examination"))
//                                .padding()
//                        }.sheet(isPresented: $showingNewExam) {
//
//                            GraphExamView(profile: self.profile)
//
//                        }
//
//                    }
//                }
//            .sheet(isPresented: $showingNewExam) {
//                GraphExamView()
//            }
            
                
            
//        }
        
        
    }
}

//struct OverView_Previews: PreviewProvider {
//    static var previews: some View {
//        OverView()
//    }
//}
