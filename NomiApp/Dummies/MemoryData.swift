//
//  MemoryData.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 12/06/26.
//

import Foundation

let memories: [Memory] = [
    Memory(
        location: "Ubud, Bali",
        title: "Morning walk through the rice terraces. The mist was still low on the fields.",
        date: .now,
        mood: .peaceful,
        liked: true
    ),

    Memory(
        location: "Gion District, Kyoto",
        title: "Walked through hidden streets and discovered a quiet cafe filled with cookies.",
        date: Calendar.current.date(
            from: DateComponents(year: 2028, month: 6, day: 12, hour: 10, minute: 15)
        ) ?? .now,
        mood: .adventurous,
        liked: false
    ),

    Memory(
        location: "Shibuya, Tokyo",
        title: "Crossed the famous intersection and watched the city come alive at night.",
        date: Calendar.current.date(
            from: DateComponents(year: 2028, month: 6, day: 15, hour: 20, minute: 45)
        ) ?? .now,
        mood: .excited,
        liked: true
    ),

    Memory(
        location: "Nusa Penida, Bali",
        title: "Spent the afternoon by the cliffs and watched the waves crash below.",
        date: Calendar.current.date(
            from: DateComponents(year: 2028, month: 6, day: 20, hour: 16, minute: 30)
        ) ?? .now,
        mood: .amazing,
        liked: false
    ),

    Memory(
        location: "Hallstatt, Austria",
        title: "The village looked exactly like a postcard covered in soft morning light.",
        date: Calendar.current.date(
            from: DateComponents(year: 2028, month: 7, day: 2, hour: 8, minute: 10)
        ) ?? .now,
        mood: .tired,
        liked: false
    ),

    Memory(
        location: "Santorini, Greece",
        title: "Watched the sunset paint the white buildings in shades of orange and pink.",
        date: Calendar.current.date(
            from: DateComponents(year: 2028, month: 7, day: 8, hour: 19, minute: 5)
        ) ?? .now,
        mood: .emotional,
        liked: false
    )
]
