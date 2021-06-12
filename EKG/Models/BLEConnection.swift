//
//  BLEConnection.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 10/04/2021.
//

import Foundation
import UIKit
import CoreBluetooth
import Combine

struct Device: Identifiable, Equatable {
    var id: Int
    let name: String
    let rssi: Int
    
    static func == (lhs: Device, rhs: Device) -> Bool {
        return lhs.name == rhs.name
    }
}

open class BLEConnection: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate, ObservableObject {    
    
    @Published public var recievedString: [UInt8] = []
    
    let passThroughSubjectPublisher = PassthroughSubject<[UInt8], Never>()
    
    //@Published public var btMessage: String?
    //@Published public var finishedExamination: Bool = false
    // Properties
    private var centralManager: CBCentralManager! = nil
    @Published public var peripheral: CBPeripheral! = nil
    var mainCharacteristic: CBCharacteristic? = nil
    
    static var frameCounter: Int = 0

    public static let bleServiceUUID = CBUUID.init(string: "4fafc201-1fb5-459e-8fcc-c5c9c331914b")
    public static let bleCharacteristicUUID = CBUUID.init(string: "beb5483e-36e1-4688-b7f5-ea07361b26a8")

    // Array to contain names of BLE devices to connect to.
    // Accessable by ContentView for Rendering the SwiftUI Body on change in this array.
    @Published var scannedBLEDevices: [CBPeripheral] = []
   
    
    func startCentralManager() {
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        print("Central Manager State: \(self.centralManager!.state)")
     
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            guard self.centralManager != nil else {
                print("Central Manager is nil [startCentralManager], aborting")
                return
            }
            self.centralManagerDidUpdateState(self.centralManager!)
        }
    }
    
    public func connect(peripheral: CBPeripheral) {
        self.centralManager?.connect(peripheral, options: nil)
        self.peripheral = peripheral
    }
    
    public func disconnect() {
        guard self.peripheral != nil else { return }
        self.centralManager.cancelPeripheralConnection(self.peripheral!)
    }

    // Handles BT Turning On/Off
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
           case .unsupported:
            print("BLE is Unsupported")
            break
           case .unauthorized:
            print("BLE is Unauthorized")
            break
           case .unknown:
            print("BLE is Unknown")
            break
           case .resetting:
            print("BLE is Resetting")
            break
           case .poweredOff:
            print("BLE is Powered Off")
            break
           case .poweredOn:
            print("Central scanning for", BLEConnection.bleServiceUUID);
            guard self.centralManager != nil else {
                print("Central Manager is nil [centralManagerDidUpdateState], aborting")
                return
            }
            self.centralManager!.scanForPeripherals(withServices: nil, options: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.centralManager!.stopScan()
            }
            break
        @unknown default:
            fatalError()
        }

       if(central.state != CBManagerState.poweredOn)
       {
           // In a real app, you'd deal with all the states correctly
        print("poweredOn")
           return
       }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        for service in peripheral.services! {
            
            print("Service found with UUID: " + service.uuid.uuidString)
            
            //device information service
            if (service.uuid.uuidString == "180A") {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
            //GAP (Generic Access Profile) for Device Name
            // This replaces the deprecated CBUUIDGenericAccessProfileString
            if (service.uuid.uuidString == "1800") {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
            //BLE Service
            if (service.uuid == BLEConnection.bleServiceUUID) {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {

        //get device name
        if (service.uuid.uuidString == "1800") {
            
            for characteristic in service.characteristics! {
                
                if (characteristic.uuid.uuidString == "2A00") {
                    peripheral.readValue(for: characteristic)
                    print("Found Device Name Characteristic")
                }
                
            }
            
        }
        
        if (service.uuid.uuidString == "180A") {
            
            for characteristic in service.characteristics! {
                
                if (characteristic.uuid.uuidString == "2A29") {
                    peripheral.readValue(for: characteristic)
                    print("Found a Device Manufacturer Name Characteristic")
                } else if (characteristic.uuid.uuidString == "2A23") {
                    peripheral.readValue(for: characteristic)
                    print("Found System ID")
                }
                
            }
            
        }
        
        if (service.uuid == BLEConnection.bleServiceUUID) {
            
            for characteristic in service.characteristics! {
                
                if (characteristic.uuid == BLEConnection.bleCharacteristicUUID) {
                    //we'll save the reference, we need it to write data
                    mainCharacteristic = characteristic
                    
                    //Set Notify is useful to read incoming data async
                    peripheral.setNotifyValue(true, for: characteristic)
                    print("3/3 Found Bluno Data Characteristic")
                    print("Connection complete")
                    
                }
                
            }
            
        }
        
    }

    // Handles the result of the scan
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Peripheral Name: \(String(describing: peripheral.name)) RSSI: \(String(RSSI.doubleValue))")
        if(!scannedBLEDevices.contains(peripheral)) {
            scannedBLEDevices.append(peripheral)
        }
    }


    // The handler if we do connect successfully
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("1/3 Connecting")
        
        peripheral.delegate = self
        
        if peripheral == self.peripheral {
            print("2/3 Connected to your BLE Board")
            peripheral.discoverServices([BLEConnection.bleServiceUUID])
        }
    }

    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Message: ", terminator: String(""))
        
        if (characteristic.uuid.uuidString == "2A00") {
            //value for device name recieved
            let deviceName = characteristic.value
            print(deviceName ?? "No Device Name")
        } else if (characteristic.uuid.uuidString == "2A29") {
            //value for manufacturer name recieved
            let manufacturerName = characteristic.value
            print(manufacturerName ?? "No Manufacturer Name")
        } else if (characteristic.uuid.uuidString == "2A23") {
            //value for system ID recieved
            let systemID = characteristic.value
            print(systemID ?? "No System ID")
        } else if (characteristic.uuid == BLEConnection.bleCharacteristicUUID) {
            //data recieved
            //print("przed ifem w didUpdateValueFor")
            if(characteristic.value != nil) {
                print(characteristic.value!)
                COMMFrameParser.ExecuteFrameData(frame: Array(characteristic.value!))
                //print("------------------------------ cos se odebralem")
                if COMMFrameParser.gotFullFrame {
                    
                    BLEConnection.frameCounter += 1
//                    print("FRAME COUNTER", BLEConnection.frameCounter)
//                    print("frameEntries.count", COMMFrameParser.frameEntries.count)
                    //print("received string", COMMFrameParser.frameEntries)
                    
                    self.recievedString = COMMFrameParser.frameEntries
                    passThroughSubjectPublisher.send(COMMFrameParser.frameEntries)
                    print("frame length", COMMFrameParser.frameEntries.count)
                    COMMFrameParser.gotFullFrame = false
                    COMMFrameParser.frameEntries.removeAll()
                    //self.finishedExamination = true
                    
                    
                    
                }
                
            }
        }
    }

    
    public func sendData(data: [UInt8]) {
        var dataToSend = Data()
        dataToSend.append(contentsOf: data)
        print(dataToSend)
        if self.peripheral != nil {
            self.peripheral!.writeValue(dataToSend, for: mainCharacteristic!, type: CBCharacteristicWriteType.withResponse)
            //btMessage = nil
        } else {
            print("Haven't discovered device yet.")
            //btMessage = "Haven't discovered device yet."
            return
        }

    }
    
    
}

