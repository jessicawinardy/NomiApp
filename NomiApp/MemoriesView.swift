//
//  MemoriesView.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 16/06/26.
//

import SwiftUI
import SwiftData

struct MemoriesView: View {
    private let place: Place?
    
    @Query(sort: \Memory.date, order: .reverse) private var memories: [Memory]
    @State private var searchText: String = ""
    @State private var isGridView: Bool = false
    
    private let galleryColumns = [
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4)
    ]
    
    private let listColumns = [
        GridItem(.flexible(), spacing: 16)
    ]
    
    init(place: Place? = nil) {
        self.place = place
    }

    private var filteredMemories: [Memory] {
        memories.filter { memory in
            let matchesPlace = place.map { memory.place?.id == $0.id } ?? true
            guard matchesPlace else { return false }

            guard !isGridView else { return true }
            guard !searchText.isEmpty else { return true }

            return memory.title.localizedCaseInsensitiveContains(searchText) ||
            memory.location.localizedCaseInsensitiveContains(searchText) ||
            memory.place?.name.localizedCaseInsensitiveContains(searchText) == true ||
            memory.place?.country.localizedCaseInsensitiveContains(searchText) == true
        }
    }

    var body: some View {
            VStack(spacing: isGridView ? 8 : 16) {
                HStack {
                    Text(place?.name ?? "Memories")
                        .font(.custom("PlayfairDisplay-Bold", size: 36))
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal, 28)
//                .padding(.top, 20)

                if !isGridView {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.greyAccent)

                        TextField("Search for a memory", text: $searchText)
                            .autocorrectionDisabled()

                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .background {
                        Color(.lightOrange)
                    }
                    .cornerRadius(15)
                    .padding(.horizontal, 28)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }

                ScrollView {
                    if filteredMemories.isEmpty {
                        VStack(spacing: 8) {
                            Text("No memories found")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Try searching for another memory, place, or country.")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, minHeight: 240)
                        .padding(.horizontal, 28)
                        .padding(.bottom, 96)
                    } else {
                        if isGridView {
                            GeometryReader { innerGeometry in
                                let galleryCellSize = max((innerGeometry.size.width - 8) / 3, 0)
                                let rowCount = max((filteredMemories.count + 2) / 3, 1)
                                let estimatedHeight = CGFloat(rowCount) * galleryCellSize

                                LazyVGrid(
                                    columns: galleryColumns,
                                    spacing: 4
                                ) {
                                    ForEach(filteredMemories) { memory in
                                        NavigationLink(value: ContentView.Route.memory(memory)) {
                                            if let data = memory.imageData, let uiImage = UIImage(data: data) {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: galleryCellSize, height: galleryCellSize)
                                                    .clipped()
                                            } else {
                                                ZStack {
                                                    Color.greyAccent.opacity(0.2)
                                                    Image(systemName: "photo")
                                                        .foregroundColor(.gray)
                                                }
                                                .frame(width: galleryCellSize, height: galleryCellSize)
                                            }
                                        }
                                    }
                                }
                                .frame(minHeight: estimatedHeight)
                            }
                            .padding(.top, 8)
                            .padding(.bottom, 96)
                        } else {
                            LazyVGrid(
                                columns: listColumns,
                                spacing: 16
                            ) {
                                ForEach(filteredMemories) { memory in
                                    MemoryCard(memory: memory)
                                }
                            }
                            .padding(.horizontal, 28)
                            .padding(.top, 8)
                            .padding(.bottom, 96)
                        }
                    }
                }
            }

            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            isGridView.toggle()
                            if isGridView {
                                searchText = ""
                            }
                        }
                    }) {
                        Image(systemName: isGridView ? "list.bullet" : "square.grid.3x3.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.blueAccent)
                    }
                }
            }
        }
}

#Preview {
    MemoriesView()
        .modelContainer(SampleData.previewContainer)
}
