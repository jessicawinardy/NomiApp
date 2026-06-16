import SwiftUI
import SwiftData

struct CreateMemoryView: View {
    let image: UIImage
    var onDismiss: () -> Void
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: \Place.name, order: .forward) private var availablePlaces: [Place]
    
    @State private var selectedPlace: Place?
    @State private var locationDetails: String = ""
    @State private var quickThoughtText: String = ""
    @State private var selectedMood: Mood = .peaceful
    
    @State private var showAddNewPlaceSheet = false
    @State private var newPlaceName = ""
    @State private var newCountryName = ""
    
    let moods: [(Mood, String)] = [
        (.amazing, Mood.amazing.icon),
        (.peaceful, Mood.peaceful.icon),
        (.excited, Mood.excited.icon),
        (.emotional, Mood.emotional.icon),
        (.tired, Mood.tired.icon),
        (.adventurous,Mood.adventurous.icon)
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
                            
                            Button(action: { showAddNewPlaceSheet = true }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add New Place")
                                }
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.blueAccent)
                            }
                        }
                        
                        HStack {
                            Image(systemName: "mappin")
                                .foregroundColor(.orangeAccent)
                            
                            Menu {
                                Picker("Select Place", selection: $selectedPlace) {
                                    Text("Select a city...").tag(Place?.none)
                                    ForEach(availablePlaces) { place in
                                        Text("\(place.name), \(place.country)").tag(Place?.some(place))
                                    }
                                }
                                .pickerStyle(.inline)
                            } label: {
                                
                                HStack {
                                    if let place = selectedPlace {
                                        Text("\(place.name), \(place.country)")
                                            .foregroundColor(.primary)
                                    } else {
                                        Text("Select a city...")
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .font(.system(size: 16, weight: .regular))
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 12)
                        .background(Color.lightOrange)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        TextField("Specific spot (e.g. Tegalalang rice field)", text: $locationDetails)
                            .font(.system(size: 15))
                            .autocorrectionDisabled()
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(
                                Color(.lightOrange)
                                    .opacity(0.5)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
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
                                            .foregroundStyle(
                                                selectedMood == item.0 ? Color.white : Color.orangeAccent.opacity(
                                                    0.5
                                                )
                                            )
                                        Text(item.0.title).font(.system(size: 11, weight: .medium))
                                            .foregroundStyle(selectedMood == item.0 ? Color.white : Color.gray)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 70)
                                    .background(
                                        selectedMood == item.0 ? Color.blueAccent : Color.lightOrange
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(
                                                selectedMood == item.0 ? Color.blueAccent : Color.clear,
                                                lineWidth: 1.5
                                            )
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
                    Button(action: {
                        onDismiss()
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                            .fontWeight(.semibold)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let finalLocation = locationDetails.isEmpty ? (selectedPlace?.name ?? "Unknown") : locationDetails
                        
                        let newMemory = Memory(
                            location: finalLocation,
                            title: quickThoughtText,
                            date: .now,
                            mood: selectedMood,
                            liked: false
                        )
                        
                        if let place = selectedPlace {
                            newMemory.place = place
                        }
                        
                        modelContext.insert(newMemory)
                        
                        onDismiss()
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.blueAccent)
                    .disabled(selectedPlace == nil)
                }
            }
        }
    }
}

#Preview {
    CreateMemoryView(image: .image, onDismiss: {})
        .modelContainer(SampleData.previewContainer)
}
