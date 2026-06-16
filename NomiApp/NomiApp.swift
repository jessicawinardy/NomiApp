//
//  NomiAppApp.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 10/06/26.
//

import SwiftUI
import SwiftData

@main
struct NomiAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Place.self,
            Memory.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do{
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch{
            fatalError("Error initializing storage")
        }
    }()
    var body: some Scene {
        
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
