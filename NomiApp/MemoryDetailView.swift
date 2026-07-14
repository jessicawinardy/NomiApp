import SwiftUI
import SwiftData

struct MemoryDetail: View {
    @Bindable var memory: Memory
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    @Query private var allMemories: [Memory]
    
    @State private var showDeleteAlert = false
    @State private var showEditSheet = false

    private var relatedMemories: [Memory] {
        guard let currentPlaceId = memory.place?.id else { return [] }
        
        return allMemories.filter { item in
            item.place?.id == currentPlaceId && item.id != memory.id
        }
    }

    private var heroHeight: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 600 : 540
    }

    private var moodColumns: [GridItem] {
        if dynamicTypeSize.isAccessibilitySize {
            return [GridItem(.flexible()), GridItem(.flexible())]
        }

        return [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                ZStack(alignment: .bottomLeading) {
                    VStack {
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 10) {
                            if dynamicTypeSize.isAccessibilitySize {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                                        Image(systemName: "mappin")
                                        Text(memory.location)
                                            .lineLimit(2)
                                    }
                                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                                        Image(systemName: "clock")
                                        Text(memory.date.formatted(date: .omitted, time: .shortened))
                                    }
                                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                                        Image(systemName: "calendar")
                                        Text(memory.date.formatted(date: .long, time: .omitted))
                                            .lineLimit(2)
                                    }
                                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                                        Image(systemName: memory.mood.icon)
                                        Text(memory.mood.title)
                                    }
                                }
                                .font(.footnote.weight(.medium))
                                .foregroundColor(.white)
                            } else {
                                HStack(spacing: 36) {
                                    VStack(alignment: .leading, spacing: 10) {
                                        HStack {
                                            Image(systemName: "mappin")
                                            Text(memory.location)
                                                .lineLimit(1)
                                        }
                                        HStack {
                                            Image(systemName: "clock")
                                            Text(memory.date.formatted(date: .omitted, time: .shortened))
                                        }
                                    }
                                    VStack(alignment: .leading, spacing: 10) {
                                        HStack {
                                            Image(systemName: "calendar")
                                            Text(memory.date.formatted(date: .long, time: .omitted))
                                                .lineLimit(2)
                                        }
                                        HStack {
                                            Image(systemName: memory.mood.icon)
                                            Text(memory.mood.title)
                                        }
                                    }
                                }
                                .font(.footnote.weight(.medium))
                                .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 20)
                        .background {
                            ZStack {
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                            }
                            .opacity(0.5)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            .white.opacity(0.5),
                                            .clear,
                                            .white.opacity(0.3)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                        .padding(.horizontal, 28)
                        .padding(.bottom, 28)
                    }
                }
                .frame(height: heroHeight)
                .frame(maxWidth: .infinity)
                .background {
                    if let data = memory.imageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(3/4, contentMode: .fill)
                            .overlay {
                                LinearGradient(
                                    colors: [
                                        .black.opacity(0.3),
                                        .clear,
                                        .black.opacity(0.5)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            }
                    } else {
                        Image(.image)
                            .resizable()
                            .scaledToFill()
                            .overlay {
                                LinearGradient(
                                    colors: [
                                        .black.opacity(0.3),
                                        .clear,
                                        .black.opacity(0.5)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            }
                    }
                }
                .clipShape(Rectangle())
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("\"" + memory.title + "\"")
                        .font(.custom("PlayfairDisplay-BoldItalic", size: 20, relativeTo: .title2))
                        .foregroundColor(.primary)
                        .lineLimit(3)
                    
                    Divider()
                    
                    Text("MORE FROM " + (memory.place?.name.uppercased() ?? "UNKNOWN PLACE"))
                        .font(.caption.weight(.bold))
                        .foregroundColor(.greyAccent)
                        .tracking(1)
                    
                    if relatedMemories.isEmpty {
                        Text("No related memories yet, go ahead and create one!")
                            .font(.callout)
                            .foregroundColor(.greyAccent)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        LazyVStack(spacing: 16) {
                            ForEach(relatedMemories) { relatedMemory in
                                MemoryCard(memory: relatedMemory)
                            }
                        }
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 28)
            }
        }
        .ignoresSafeArea(edges: .top)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.5)) {
                        memory.liked.toggle()
                    }
                }) {
                    Image(systemName: memory.liked ? "heart.fill" : "heart")
                        .foregroundColor(memory.liked ? .red : .blueAccent)
                }
                .buttonStyle(.plain)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { showEditSheet = true }) {
                        Label("Edit Memory", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive, action: { showDeleteAlert = true }) {
                        Label("Delete Memory", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.blueAccent)
                }
                .buttonStyle(.plain)
            }
        }
        .alert("Delete Memory", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                modelContext.delete(memory)
                try? modelContext.save()
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to permanently delete this memory?")
        }
        .sheet(isPresented: $showEditSheet) {
            EditMemorySheet(memory: memory)
        }
    }
}

struct EditMemorySheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable var memory: Memory
    
    @State private var editCity: String = ""
    @State private var editCountry: String = ""
    @State private var editLocationDetails: String = ""
    @State private var editTitle: String = ""
    @State private var editMood: Mood = .peaceful
    
    private let moods: [(Mood, String)] = [
        (.amazing, Mood.amazing.icon),
        (.peaceful, Mood.peaceful.icon),
        (.excited, Mood.excited.icon),
        (.emotional, Mood.emotional.icon),
        (.tired, Mood.tired.icon),
        (.adventurous, Mood.adventurous.icon)
    ]

    private var moodColumns: [GridItem] {
        if dynamicTypeSize.isAccessibilitySize {
            return [GridItem(.flexible()), GridItem(.flexible())]
        }

        return [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("LOCATION")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.gray)
                            .tracking(1)
                        
                        HStack(spacing: 12) {
                            HStack {
                                Image(systemName: "building.2")
                                    .foregroundColor(.orangeAccent)
                                TextField("City", text: $editCity)
                                    .font(.body)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color.lightOrange)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            
                            HStack {
                                Image(systemName: "globe")
                                    .foregroundColor(.orangeAccent)
                                TextField("Country", text: $editCountry)
                                    .font(.body)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color.lightOrange)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        HStack {
                            Image(systemName: "mappin")
                                .foregroundColor(.orangeAccent)
                            TextField("Specific spot", text: $editLocationDetails)
                                .font(.body)
                                .autocorrectionDisabled()
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Color.lightOrange)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("HOW ARE YOU FEELING?")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.gray)
                            .tracking(1)
                        
                        LazyVGrid(columns: moodColumns, spacing: 12) {
                            ForEach(moods, id: \.0) { item in
                                Button(action: { editMood = item.0 }) {
                                    VStack(spacing: 6) {
                                        Image(systemName: item.1)
                                            .font(.system(size: dynamicTypeSize.isAccessibilitySize ? 22 : 26))
                                            .foregroundStyle(editMood == item.0 ? Color.white : Color.orangeAccent.opacity(0.7))
                                        Text(item.0.title)
                                            .font(.callout.weight(.medium))
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.9)
                                            .foregroundStyle(editMood == item.0 ? Color.white : Color.gray)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: dynamicTypeSize.isAccessibilitySize ? 84 : 70)
                                    .background(editMood == item.0 ? Color.blueAccent : Color.lightOrange)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(editMood == item.0 ? Color.blueAccent : Color.clear, lineWidth: 1.5)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("QUICK THOUGHT")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.gray)
                            .tracking(1)
                        
                        TextEditor(text: $editTitle)
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: dynamicTypeSize.isAccessibilitySize ? 160 : 120)
                            .padding(12)
                            .background(Color.lightOrange.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                Group {
                                    if editTitle.isEmpty {
                                        Text("What's on your mind?")
                                            .font(.body)
                                            .foregroundColor(.gray.opacity(0.7))
                                            .padding(.leading, 16)
                                            .padding(.top, 18)
                                    }
                                }, alignment: .topLeading
                            )
                    }
                }
                .padding(.horizontal, 28)
                .padding(.top, 20)
                .padding(.bottom, 30)
            }
            .navigationTitle("Edit Memory")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                editCity = memory.place?.name ?? ""
                editCountry = memory.place?.country ?? ""
                editLocationDetails = memory.location
                editTitle = memory.title
                editMood = memory.mood
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.body.weight(.medium))
                    .foregroundColor(.gray)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        memory.location = editLocationDetails
                        memory.title = editTitle
                        memory.mood = editMood
                        
                        if let existingPlace = memory.place {
                            existingPlace.name = editCity
                            existingPlace.country = editCountry
                        }
                        
                        dismiss()
                    }
                    .font(.body.weight(.bold))
                    .foregroundColor(.blueAccent)
                    .disabled(editCity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    MemoryDetail(
        memory: Memory(
            location: "Preview Location",
            title: "Preview Memory",
            date: .now,
            mood: .peaceful,
            liked: false
        )
    )
    .modelContainer(SampleData.previewContainer)
}
