import SwiftUI
import SwiftData
import CoreLocation

struct CreateMemoryView: View {
    let image: UIImage
    var onDismiss: () -> Void
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var cityName: String = ""
    @State private var countryName: String = ""
    @State private var locationDetails: String = ""
    @State private var lastMapCoordinate: CLLocationCoordinate2D? = nil
    
    @State private var quickThoughtText: String = ""
    @State private var selectedMood: Mood = .peaceful
    
    @State private var showMapSheet = false
    @State private var showSaveErrorAlert = false
    @State private var errorMessage = ""
    
    let moods: [(Mood, String)] = [
        (.amazing, Mood.amazing.icon),
        (.peaceful, Mood.peaceful.icon),
        (.excited, Mood.excited.icon),
        (.emotional, Mood.emotional.icon),
        (.tired, Mood.tired.icon),
        (.adventurous, Mood.adventurous.icon)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("Create Memory")
                            .font(.custom("PlayfairDisplay-Bold", size: 36))
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(3/4, contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: 380)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("LOCATION")
                                .font(Font.system(size: 11, weight: .bold))
                                .foregroundColor(.gray)
                                .tracking(1)
                            
                            Spacer()
                            
                            Button(action: { showMapSheet = true }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "map.fill")
                                    Text("Pick from Map")
                                }
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.blueAccent)
                            }
                        }
                        
                        HStack(spacing: 12) {
                            HStack {
                                Image(systemName: "building.2")
                                    .foregroundColor(.orangeAccent)
                                TextField("City", text: $cityName)
                                    .font(.system(size: 15))
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color.lightOrange)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            
                            HStack {
                                Image(systemName: "globe")
                                    .foregroundColor(.orangeAccent)
                                TextField("Country", text: $countryName)
                                    .font(.system(size: 15))
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color.lightOrange)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        HStack {
                            Image(systemName: "mappin")
                                .foregroundColor(.orangeAccent)
                            TextField("Specific spot (e.g. Tegalalang rice field)", text: $locationDetails)
                                .font(.system(size: 15))
                                .autocorrectionDisabled()
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Color.lightOrange)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .sheet(isPresented: $showMapSheet) {
                        DirectMapPicker(initialCoordinate: lastMapCoordinate) { kota, negara, coordinate in
                            self.cityName = kota
                            self.countryName = negara
                            self.lastMapCoordinate = coordinate
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("HOW ARE YOU FEELING?")
                            .font(Font.system(size: 11, weight: .bold))
                            .foregroundColor(.gray)
                            .tracking(1)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(moods, id: \.0) { item in
                                Button(action: { selectedMood = item.0 }) {
                                    VStack(spacing: 6) {
                                        Image(systemName: item.1).font(.system(size: 26))
                                            .foregroundStyle(selectedMood == item.0 ? Color.white : Color.orangeAccent.opacity(0.7))
                                        Text(item.0.title).font(.system(size: 11, weight: .medium))
                                            .foregroundStyle(selectedMood == item.0 ? Color.white : Color.gray)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 70)
                                    .background(selectedMood == item.0 ? Color.blueAccent : Color.lightOrange)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(selectedMood == item.0 ? Color.blueAccent : Color.clear, lineWidth: 1.5)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                  
                    VStack(alignment: .leading, spacing: 8) {
                        Text("QUICK THOUGHT")
                            .font(Font.system(size: 11, weight: .bold))
                            .foregroundColor(.gray)
                            .tracking(1)
                        
                        TextEditor(text: $quickThoughtText)
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 120)
                            .padding(12)
                            .background(Color.lightOrange.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                Group {
                                    if quickThoughtText.isEmpty {
                                        Text("What's on your mind?")
                                            .foregroundColor(.gray.opacity(0.7))
                                            .padding(.leading, 16)
                                            .padding(.top, 20)
                                    }
                                }, alignment: .topLeading
                            )
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 30)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onDismiss()
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let cleanCity = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
                        let cleanCountry = countryName.trimmingCharacters(in: .whitespacesAndNewlines)
                        let specificSpot = locationDetails.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        var resolvedPlace: Place? = nil
                        
                        if !cleanCity.isEmpty {
                            let descriptor = FetchDescriptor<Place>()
                            
                            do {
                                let allPlaces = try modelContext.fetch(descriptor)
                                resolvedPlace = allPlaces.first(where: { $0.name.lowercased() == cleanCity.lowercased() })
                            } catch {
                                print("Error reading database: \(error.localizedDescription)")
                                errorMessage = error.localizedDescription
                                showSaveErrorAlert = true
                                return
                            }
                        }
                    
                        let newMemory = Memory(
                            location: specificSpot,
                            title: quickThoughtText,
                            date: .now,
                            mood: selectedMood,
                            liked: false,
                            imageData: image.jpegData(compressionQuality: 0.8)
                        )
                        
                        if let existingPlace = resolvedPlace {
                            newMemory.place = existingPlace
                        } else if !cleanCity.isEmpty {
                          
                            let newPlace = Place(name: cleanCity, country: cleanCountry, imageName: "image")
                            modelContext.insert(newPlace)
                            newMemory.place = newPlace
                        }
                        
                        modelContext.insert(newMemory)
                        
                        onDismiss()
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.blueAccent)
                    .disabled(cityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .alert("Could Not Save Memory", isPresented: $showSaveErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
}

#Preview {
    CreateMemoryView(image: UIImage(resource: .image), onDismiss: {})
        .modelContainer(SampleData.previewContainer)
}
