//
//  BTView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 10/04/2021.
//

import SwiftUI
import CoreBluetooth

struct BTView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    var profile: Profile
    
    @ObservedObject var bleConnection: BLEConnection
    
    var body: some View {

            
        List(bleConnection.scannedBLEDevices, id: \.self) { device in
            
            HStack {
                Button(action: {
                    
                    print("Trying to connect to: \(device.name!)")
                    bleConnection.connect(peripheral: device)
                    
//                    let profile = self.profile
//                    profile.deviceUUID = device.identifier
//
//                    try? self.viewContext.save()
                    
                },
                label: {
                    
                    Text("\(device.name!)")
                    
                })
                
                Spacer()
                if device.name! == self.bleConnection.peripheral?.name {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color(.systemBlue))
                } else {
                    EmptyView()
                }
                
            }
        }.listStyle(PlainListStyle())
        
        
        .onAppear(perform: {
            bleConnection.scannedBLEDevices = []
            bleConnection.startCentralManager()
        })
        
        .navigationTitle("Bluetooth Devices")
        
    }
}

struct BTView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        BTView(profile: Profile(), bleConnection: BLEConnection())
    }
}
