//
//  PlacesView.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 11/06/26.
//

import SwiftUI

struct PlacesView: View {
    @State private var searchText: String = ""

    private var filteredPlaces: [Place] {
        guard !searchText.isEmpty else { return places }

        return places.filter { place in
            place.name.localizedCaseInsensitiveContains(searchText) ||
            place.country.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack {
                    Text("Places")
                        .font(.custom("PlayfairDisplay-Bold", size: 36))
                        .fontWeight(.bold)
                    Spacer()
                    Image(.image)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(.horizontal, 28)
                .padding(.top, 20)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.greyAccent)
                                
                    TextField("Search for a place", text: $searchText)
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
                    .background{
                        Color(.orangeAccent)
                        .opacity(0.1)}
                    .cornerRadius(15)
                    .padding(.horizontal, 28)
                
                ScrollView {
                    if filteredPlaces.isEmpty {
                        VStack(spacing: 8) {
                            Text("No places found")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Try searching for other place or country.")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, minHeight: 240)
                        .padding(.horizontal, 28)
                    } else {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ],
                            spacing: 16
                        ) {
                            ForEach(filteredPlaces) { place in
                                PlaceCard(place: place)
                            }
                        }
                        .padding(.horizontal, 28)
                        .padding(.top, 8)
                    }
                }
            }
        }
    }
}


#Preview {
    PlacesView()
}
