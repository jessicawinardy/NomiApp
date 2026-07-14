//
//  ContentView.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 10/06/26.
//

import SwiftUI
import SwiftData
//import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var existingPlaces: [Place]
    @State private var selectedTab: Int = 0

    enum Route: Hashable {
        case memory(Memory)
        case place(Place)
        case memories(place: Place?)
        case favorites
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                JournalView()
                    .tabItem {
                        Label("Journal", systemImage: "book")
                    }
                    .tag(0)
                CameraView(isCameraTabActive: selectedTab == 1)
                    .tabItem {
                        Label("Camera", systemImage: "camera")
                    }
                    .tag(1)
                PlacesView()
                    .tabItem {
                        Label("Places", systemImage: "mappin.and.ellipse")
                    }
                    .tag(2)
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .memory(let memory):
                    MemoryDetail(memory: memory)
                case .place(let place):
                    MemoriesView(place: place)
                case .memories(let place):
                    MemoriesView(place: place)
                case .favorites:
                    FavoritesView()
                }
            }
        }
        .onAppear{
            if existingPlaces.isEmpty{
                SampleData.insertSampleData(into: modelContext)
            }
        }
        .background(.appBg)
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.previewContainer)
}
