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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(SampleData.previewContainer)
    }
}
