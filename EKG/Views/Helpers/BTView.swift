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
    
    @ObservedObject var profile: Profile
    
    @ObservedObject var bleConnection: BLEConnection
    
    
    var body: some View {

            
        List(bleConnection.scannedBLEDevices, id: \.self) { device in
            
            HStack {
                Button(action: {
                    
                    print("Trying to connect to: \(device.name!)")
                    bleConnection.connect(peripheral: device)
                    
//                    DispatchQueue.global(qos: .utility).async {
//                        
//                        let profile = self.profile
//                        profile.deviceUUID = device.identifier
//                        
//                        DispatchQueue.main.async {
//                            try? self.viewContext.save()
//                        }
//                        
//                    }
                    
                },
                label: {
                    
                    Text(Formatters.removeNewLine(string: device.name ?? "N/A"))
                    
                })
                
                Spacer()
                if device.name ?? "N/A" == self.bleConnection.peripheral?.name {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color("\(profile.wrappedColor)"))
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
