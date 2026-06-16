//
//  MemoryCard.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 10/06/26.
//

import SwiftUI
import Foundation
import SwiftData

struct MemoryCard: View {
    let memory: Memory
    
    var body: some View {
        NavigationLink(value: memory) {
            GeometryReader { proxy in
                HStack(alignment: .center, spacing: 12) {
                    Image(.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 20))

                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 2) {
                            Image(systemName: "mappin")
                            Text(memory.location)
                        }
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color.orange)

                        Text(memory.title)
                            .font(.system(size: 13, weight: .medium))
                            .lineLimit(3)

                        HStack(spacing: 8) {
                            Text(memory.date.formatted(date: .long, time: .omitted))

                            Text("·")

                            HStack(spacing: 2) {
                                Image(systemName: memory.mood.icon)
                                Text(memory.mood.title)
                            }
                        }
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    }
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.greyAccent)
                        .opacity(0.5)
                }
                .frame(maxWidth: proxy.size.width, alignment: .leading)
            }
            .frame(height: 80)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MemoryCard(
        memory: Memory(
            location: "Ubud, Bali",
            title: "Morning walk through the rice terraces.",
            date: .now,
            mood: .peaceful,
            liked: true
        )
    )
        .modelContainer(SampleData.previewContainer)
}
