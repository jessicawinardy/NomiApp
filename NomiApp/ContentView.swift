//
//  ContentView.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 10/06/26.
//

import SwiftUI
//import SwiftData

struct ContentView: View {
//    @State private var selectedTab: TabItem = .journal
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
                TabView {
                    JournalView()
                        .tabItem {
                            Label("Journal", systemImage: "book")
                        }
                    CameraView()
                        .tabItem {
                            Label("Camera", systemImage: "camera")
                        }
                    PlacesView()
                        .tabItem {
                            Label("Places", systemImage: "mappin.and.ellipse")
                        }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
