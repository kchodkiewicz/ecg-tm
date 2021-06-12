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
    
    var deviceList: [CBPeripheral] = []
    
    var body: some View {
        
        
        List(
            bleConnection.scannedBLEDevices.filter({
                $0.name != nil
            }
            ), id: \.self) { device in
            if let name = device.name {
                HStack {
                    Button(action: {
                        if self.bleConnection.peripheral == nil {
                            print("Trying to connect to: \(device.name!)")
                            bleConnection.connect(peripheral: device)
                        } else {
                            print("Disconnecting")
                            bleConnection.disconnect()
                        }
                        
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
                        
                        Text("\(name)")
                        
                    })
                    
                    Spacer()
                    if name == self.bleConnection.peripheral?.name {
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                        //.foregroundColor(Color("\(profile.wrappedColor)"))
                    } else {
                        EmptyView()
                    }
                    
                }
            }
        }.listStyle(PlainListStyle())
        
        
        .onAppear(perform: {
            bleConnection.scannedBLEDevices = []
            bleConnection.startCentralManager()
            
        })
        
        .navigationTitle("Bluetooth Devices")
        
    }
    
    //    init(profile: Profile, bleConnection: BLEConnection) {
    //        self.profile = profile
    //        self.bleConnection = bleConnection
    //        self.deviceList = []
    //
    //        self.bleConnection.scannedBLEDevices = []
    //        self.bleConnection.startCentralManager()
    //
    //        self.deviceList = bleConnection.scannedBLEDevices.filter({
    //            $0.name != nil
    //        })
    //    }
}

struct BTView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        BTView(profile: Profile(), bleConnection: BLEConnection())
    }
}
