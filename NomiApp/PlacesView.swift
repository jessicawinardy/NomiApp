//
//  PlacesView.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 11/06/26.
//

import SwiftUI
import SwiftData

struct PlacesView: View {
    @Query(sort: \Place.name, order: .forward) private var places: [Place]
    @State private var searchText: String = ""
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    @Query(sort: \Memory.date, order: .reverse) private var allMemories: [Memory]
    
    private var favoriteMemories: [Memory]{
        allMemories.filter{ $0.liked}
    }

    private var filteredPlaces: [Place] {
        guard !searchText.isEmpty else { return places }

        return places.filter { place in
            place.name.localizedCaseInsensitiveContains(searchText) ||
            place.country.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var latestMemoryImage: UIImage {
        if let latestMemoryWithImage = allMemories.first(where: { $0.imageData != nil }),
           let data = latestMemoryWithImage.imageData,
           let uiImage = UIImage(data: data) {
            return uiImage
        }

        return UIImage(resource: .image)
    }
    
    private var latestFavoriteImage: UIImage{
        guard let latestFavImageData = favoriteMemories.first,
        let data = latestFavImageData.imageData,
        let uiImage = UIImage(data: data) else {
            return UIImage(resource: .image)
        }
        return uiImage
    }

    private var placeGridColumns: [GridItem] {
        if dynamicTypeSize.isAccessibilitySize {
            return [GridItem(.flexible(), spacing: 16)]
        }

        return [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ]
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Places")
                    .font(.custom("PlayfairDisplay-Bold", size: 36, relativeTo: .largeTitle))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                Spacer()
            }
            .padding(.horizontal, 28)

            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.greyAccent)

                TextField("Search for a place", text: $searchText)
                    .font(.body)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background {
                Color(.lightOrange)
            }
            .cornerRadius(15)
            .padding(.horizontal, 28)

            ScrollView {
                if filteredPlaces.isEmpty {
                    VStack(spacing: 8) {
                        Text("No places found")
                            .font(.headline)
                            .multilineTextAlignment(.center)

                        Text("Try searching for another place or country.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, minHeight: 240)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 96)
                } else {
                    LazyVGrid(columns: placeGridColumns, spacing: 16) {
                        if searchText.isEmpty {
                            NavigationLink(value: ContentView.Route.memories(place: nil)) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Spacer()

                                    Text("All Memories")
                                        .font(.title3.weight(.bold))
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.85)

                                    HStack(spacing: 4) {
                                        Image(systemName: "photo.stack")
                                        Text("\(allMemories.count) Memories")
                                    }
                                    .font(.caption.weight(.medium))
                                    .foregroundColor(.white.opacity(0.7))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                                }
                                .padding(20)
                                .frame(maxWidth: .infinity, minHeight: 200, alignment: .bottomLeading)
                                .background {
                                    Image(uiImage: latestMemoryImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(minHeight: 200)
                                        .overlay {
                                            LinearGradient(
                                                colors: [
                                                    .clear,
                                                    .black.opacity(0.2),
                                                    .black.opacity(0.55)
                                                ],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(
                                    color: .black.opacity(0.2),
                                    radius: 5,
                                    x: 3,
                                    y: 3
                                )
                            }
                            .buttonStyle(.plain)
                            NavigationLink(value: ContentView.Route.favorites) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Spacer()

                                    Text("Favorites")
                                        .font(.title3.weight(.bold))
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.85)

                                    HStack(spacing: 4) {
                                        Image(systemName: "love")
                                        Text(
                                            "\(favoriteMemories.count) Memories"
                                        )
                                    }
                                    .font(.caption.weight(.medium))
                                    .foregroundColor(.white.opacity(0.7))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                                }
                                .padding(20)
                                .frame(maxWidth: .infinity, minHeight: 200, alignment: .bottomLeading)
                                .background {
                                    Image(uiImage: latestFavoriteImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(minHeight: 200)
                                        .overlay {
                                            LinearGradient(
                                                colors: [
                                                    .clear,
                                                    .black.opacity(0.2),
                                                    .black.opacity(0.55)
                                                ],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(
                                    color: .black.opacity(0.2),
                                    radius: 5,
                                    x: 3,
                                    y: 3
                                )
                            }
                            .buttonStyle(.plain)
                        }

                        ForEach(filteredPlaces) { place in
                            PlaceCard(place: place)
                        }
                    }
                    .padding(.horizontal, 28)
                    .padding(.bottom, 96)
                }
            }
        }
    }
}

#Preview {
    PlacesView()
        .modelContainer(SampleData.previewContainer)
}
