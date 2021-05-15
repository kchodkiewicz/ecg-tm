//
//  EKGApp.swift
//  EKG
//
//  Created by Krzysztof Chodkiewicz on 08/03/2021.
//

import SwiftUI

@main
struct EKGApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(ActiveSession())
                .environmentObject(COMMFrameParser())
        }
    }
}
