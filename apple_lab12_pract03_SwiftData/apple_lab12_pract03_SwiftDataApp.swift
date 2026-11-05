//
//  apple_lab12_pract03_SwiftDataApp.swift
//  apple_lab12_pract03_SwiftData
//

import SwiftUI
import SwiftData

@main
struct apple_lab12_pract03_SwiftDataApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Teacher.self,
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
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
