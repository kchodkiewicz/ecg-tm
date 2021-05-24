//
//  OverView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 13/03/2021.
//

import SwiftUI
import CoreBluetooth
import Combine


struct TabHost: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    //@EnvironmentObject var activeSession: ActiveSession
    
    @ObservedObject var bleConnection: BLEConnection = BLEConnection()
    
    @ObservedObject var profile: Profile
    
    @Binding var dismiss: Bool
    
    @State var selectedTab: Tab = .history
    @State var goToBluetooth: Bool? = false
    
    @State var isShowingLogin: Bool = true
    
    private func connectBLEDevice() {
        if bleConnection.peripheral == nil {
            // Start Scanning for BLE Devices
            bleConnection.startCentralManager()
            
            //TODO: try connecting to saved device (CoreData: Profile.btRRSI <- add)
            if let devUUID = profile.deviceUUID {
              // try filtering list of devices with RSSI
                let peripheral = bleConnection.scannedBLEDevices.first { CBPeripheral in
                    CBPeripheral.identifier == devUUID
                }
                guard peripheral != nil else {
                    return
                }
                bleConnection.connect(peripheral: peripheral!)
            }
        }
    }
    
    var body: some View {
        //if !self.isShowingLogin {
        TabView(selection: $selectedTab) {
            // History
            NavigationView {
                HistoryOverview(profile: profile, switchTab: $selectedTab)
                //Text("Hello")
            }
        .tabItem {
                Image(systemName: "house.fill")
                    .imageScale(.large)
                    .accessibility(label: Text("History"))
                Text("History")
            }.tag(Tab.history)
            
            // Exam
            NavigationView {
                GraphExamView(bleConnection: bleConnection, profile: self.profile, switchTab: $selectedTab, goToBT: $goToBluetooth)
            }
                    .tabItem {
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
                    bleConnection: bleConnection,
                    goToBluetooth: $goToBluetooth,
                    dismiss: self.$dismiss,
                    username: self.profile.wrappedUsername,
                    firstName: self.profile.wrappedFirstName,
                    lastName: self.profile.wrappedLastName,
                    age: self.profile.wrappedAge,
                    examDuration: Int(self.profile.examDuration),
                    profileColor: ProfileColor.ColorName(value: self.profile.wrappedColor)
                )
            }
        .tabItem {
                Image(systemName: "person.crop.square.fill")
                    .imageScale(.large)
                    .accessibility(label: Text("User Profile"))
                    .padding()
                Text("Profile")
            }.tag(Tab.profile)
                
        }
        .accentColor(Color("\(profile.wrappedColor)"))
        
        .onAppear(perform: connectBLEDevice)
        
    }
}

//struct OverView_Previews: PreviewProvider {
//    static var previews: some View {
//        OverView()
//    }
//}
