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
    //@State var selection: [CBPeripheral]?
    var body: some View {
        NavigationView {
            List(bleConnection.scannedBLEDevices, id: \.self) { device in
                Button(action: {
                    print("IM CONNECTED TO " + device.name!)
                    bleConnection.connect(peripheral: device)
                }, label: {
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
