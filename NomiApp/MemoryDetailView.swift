//
//  MemoryDetail.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 12/06/26.
//

import SwiftUI
import SwiftData

struct MemoryDetail: View {
    let memory: Memory
    
    @Query private var allMemories: [Memory]

    private var relatedMemories: [Memory] {
            guard let currentPlaceId = memory.place?.id else { return [] }
            
            return allMemories.filter { item in
                item.place?.id == currentPlaceId && item.id != memory.id
            }
        }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ZStack(alignment: .bottomLeading) {
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {}) {
                                Image(systemName: memory.liked ? "heart.fill" : "heart")
                                    .foregroundColor(memory.liked ? .red : .white)
                                    .font(.system(size: 20, weight: .semibold))
                                    .padding(10)
                                    .background{
                                        ZStack{
                                            Rectangle()
                                                .fill(.ultraThinMaterial)
                                            
                                        }
                                        .opacity(0.5)
                                    }
                                    .cornerRadius(30)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
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
                            }
                        }
                        .padding(.horizontal, 28)
                        .padding(.top, 60)
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 36) {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Image(systemName: "mappin")
                                        Text(memory.location)
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
                                    }
                                    HStack {
                                        Image(systemName: memory.mood.icon)
                                        Text(memory.mood.title)
                                    }
                                }
                            }
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 20)
                        .background{
                            ZStack{
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
                .frame(height: 440)
                .frame(maxWidth: .infinity)
                .background {
                    if let data = memory.imageData, let uiImage = UIImage(
                        data: data){
                        Image(uiImage: uiImage)
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
                    else{
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
                        .font(.custom("PlayfairDisplay-BoldItalic", size: 18))
                        .foregroundColor(.primary)
                    
                    Divider()
                    
                    Text("MORE FROM " + (memory.place?.name.uppercased() ?? "UNKNOWN PLACE"))
                        .font(Font.system(size: 11, weight: .bold))
                        .foregroundColor(.greyAccent)
                        .tracking(1)
                    
                    if relatedMemories.isEmpty {
                        Text("No related memories yet, go ahead and create one!")
                            .font(.system(size: 11))
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
        .edgesIgnoringSafeArea(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
