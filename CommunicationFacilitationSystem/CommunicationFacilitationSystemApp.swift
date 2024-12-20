//
//  CommunicationFacilitationSystemApp.swift
//  CommunicationFacilitationSystem
//
//  Created by 柴谷 椋 on 2024/12/19.
//

import SwiftUI
import SwiftData

@main
struct CommunicationFacilitationSystemApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            LaunchView()
        }
        .modelContainer(sharedModelContainer)
    }
}
