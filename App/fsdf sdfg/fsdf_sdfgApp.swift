//
//  fsdf_sdfgApp.swift
//  fsdf sdfg
//
//  Created by Jaleel Akbashev on 16.06.21.
//

import SwiftUI

@main
struct fsdf_sdfgApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
