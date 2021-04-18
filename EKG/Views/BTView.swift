//
//  BTView.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 10/04/2021.
//

import SwiftUI
import CoreBluetooth

struct BTView: View {
    var bleConnection: BLEConnection
    var body: some View {
        NavigationView {
            
            Text("Bluetooth devices")
                .bold()
                .font(.title)
            
            List(bleConnection.scannedBLEDevices, id: \.self) { device in
            
                Button(action: {
                    
                    print("IM CONNECTED TO " + device.name!)
                    bleConnection.connect(peripheral: device)
                    
                },
                label: {
                    
                    Text(verbatim: device.name!)
                    
                })
            }
            
            
        }.navigationTitle("Bluetooth")
    }
}

//struct BTView_Previews: PreviewProvider {
//    static var previews: some View {
//        BTView()
//    }
//}
