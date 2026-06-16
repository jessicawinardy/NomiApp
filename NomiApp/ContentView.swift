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
    @Query private var existingPlaces: [Place]
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
//            Group {
//                switch selectedTab {
//                case .journal:
//                    JournalView()
//                case .places:
//                    MemoryCard(memory: memories[1])
//                }
//            }
            ZStack{
                TabView (selection: $selectedTab) {
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
            }
        }
        .onAppear{
            if existingPlaces.isEmpty{
                SampleData.insertSampleData(into: modelContext)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.previewContainer)
}
