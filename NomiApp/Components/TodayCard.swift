//
//  TodayCard.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 10/06/26.
//

import SwiftUI
import Foundation

struct TodayCard: View {
    let memory: Memory
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .bottomLeading) {
                    Image(.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: 290)
                        .clipped()
                        .overlay {
                            LinearGradient(
                                colors: [
                                    .clear,
                                    .black.opacity(0.1),
                                    .black.opacity(0.6)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 3, y: 3)
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(spacing: 2) {
                            Image(systemName: "mappin")
                            Text(memory.location)
                        }
                        .font(Font.system(size: 11, weight: .medium))
                        .foregroundColor(.white)
                        .opacity(0.55)
                        Text(memory.title)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                        HStack(spacing: 20) {
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                Text(
                                    memory.date
                                        .formatted(date: .omitted, time: .shortened)
                                )
                            }
                            .font(Font.system(size: 11, weight: .medium))
                            .foregroundColor(.white)
                            .opacity(0.55)
                            HStack(spacing: 4) {
                                Image(systemName: memory.mood.icon)
                                Text(memory.mood.title)
                            }
                            .font(Font.system(size: 11, weight: .medium))
                            .foregroundColor(.white)
                            .opacity(0.55)
                        }
                    }
                    .padding(24)
                }
            }
        }
        .frame(height: 290)
    }
}

#Preview {
    TodayCard(memory: Memory(
        location: "Ubud, Bali",
        title: "Morning walk through the rice terraces. Them mist was still lown on the fields.",
        date: Calendar.current.date(from: DateComponents(year: 2028, month: 6, day: 8, hour: 7, minute: 30)) ?? .now,
        mood: .peaceful
        )
    )
}
