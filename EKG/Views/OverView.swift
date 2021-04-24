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
        
        NavigationView {
            
            
            HistoryView(filter: activeSession.username)
            .layoutPriority(1)
            .padding(.leading)
            .navigationBarTitle("Overview")
            
                .toolbar {
                    // Top Toolbar
                    ToolbarItem(placement: .primaryAction) {
                        HStack {
                            Button(action: {self.showingProfile.toggle()}) {
                            Image(systemName: "person.crop.circle")
                                .imageScale(.large)
                                .accessibility(label: Text("User Profile"))
                                .padding()
                            }.sheet(isPresented: $showingProfile) {
                                
                                ProfileView(profile: profile)
                                    .environmentObject(self.activeSession)
                                
                            }
                            Spacer()
                            Button(action: {self.showingBTScan.toggle()}) {
                                Image(systemName: "antenna.radiowaves.left.and.right")
                                .imageScale(.large)
                                .accessibility(label: Text("Bluetooth connection"))
                                .padding()
                            }.sheet(isPresented: $showingBTScan) {
                                
                                BTView(bleConnection: bleConnection)
                                
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        
                       
                        // Bottom Toolbar
                        Button(action: {
                            self.showingNewExam.toggle()
                        }) {
                            Image(systemName: "waveform.path.ecg.rectangle.fill")
                                .imageScale(.large)
                                .accessibility(label: Text("New Examination"))
                                .padding()
                        }.sheet(isPresented: $showingNewExam) {
                            
                            GraphExamView(profile: self.profile, points: profile.examArray[0].sampleArray)
                            
                        }

                    }
                }
//            .sheet(isPresented: $showingNewExam) {
//                GraphExamView()
//            }
            
                
            .onAppear(perform: connectBLEDevice)
        }
        
        
    }
}

//struct OverView_Previews: PreviewProvider {
//    static var previews: some View {
//        OverView()
//    }
//}
