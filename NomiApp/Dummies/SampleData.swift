//
//  SampleData.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 14/06/26.
//

import Foundation
import SwiftData

@MainActor
struct SampleData {
    static let previewContainer: ModelContainer = {
        do {
            let schema = Schema([Place.self, Memory.self])
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: schema, configurations: [configuration])
            
            let context = container.mainContext
            
            // 1. Inisialisasi Tempat (Places)
            let tokyo = Place(name: "Tokyo", country: "Japan", imageName: "image")
            let kyoto = Place(name: "Kyoto", country: "Japan", imageName: "image")
            let bali = Place(name: "Bali", country: "Indonesia", imageName: "image")
            let hallstatt = Place(name: "Hallstatt", country: "Austria", imageName: "image")
            let santorini = Place(name: "Santorini", country: "Greece", imageName: "image")
            
            context.insert(tokyo)
            context.insert(kyoto)
            context.insert(bali)
            context.insert(hallstatt)
            context.insert(santorini)
            
            // 2. Inisialisasi Memori Jurnal (Lebih Banyak Variasi)
            let memory1 = Memory(
                location: "Ubud, Bali",
                title: "Morning walk through the rice terraces. The mist was still low on the fields.",
                date: .now,
                mood: .peaceful,
                liked: true
            )
            
            let memory2 = Memory(
                location: "Gion District, Kyoto",
                title: "Walked through hidden streets and discovered a quiet cafe filled with cookies.",
                date: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 12, hour: 10, minute: 15)) ?? .now,
                mood: .adventurous,
                liked: false
            )
            
            let memory3 = Memory(
                location: "Shibuya, Tokyo",
                title: "Crossed the famous intersection and watched the city come alive at night.",
                date: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 11, hour: 21, minute: 30)) ?? .now,
                mood: .excited,
                liked: true
            )
            
            let memory4 = Memory(
                location: "Nusa Penida, Bali",
                title: "Spent the afternoon by the cliffs and watched the crystal clear waves crash below.",
                date: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 10, hour: 15, minute: 45)) ?? .now,
                mood: .amazing,
                liked: false
            )
            
            let memory5 = Memory(
                location: "Lake Hallstatt",
                title: "The village looked exactly like a postcard covered in soft, golden morning light.",
                date: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 8, hour: 8, minute: 0)) ?? .now,
                mood: .peaceful,
                liked: true
            )
            
            let memory6 = Memory(
                location: "Oia, Santorini",
                title: "Watched the iconic sunset paint the white buildings in shades of orange and pink.",
                date: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 5, hour: 19, minute: 20)) ?? .now,
                mood: .emotional,
                liked: false
            )
            
            let memory7 = Memory(
                location: "Akihabara, Tokyo",
                title: "Explored retro arcade buildings and found some rare vintage game soundtracks.",
                date: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 3, hour: 14, minute: 0)) ?? .now,
                mood: .excited,
                liked: false
            )
            
            let memory8 = Memory(
                location: "Fushimi Inari, Kyoto",
                title: "Hiked up through thousands of red Torii gates before the afternoon crowd arrived.",
                date: Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 28, hour: 7, minute: 10)) ?? .now,
                mood: .adventurous,
                liked: true
            )
            
            let memory9 = Memory(
                location: "Seminyak, Bali",
                title: "Caught a heavy downpour inside a cozy coffee shop. Just listening to the rain.",
                date: Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 25, hour: 16, minute: 5)) ?? .now,
                mood: .tired,
                liked: false
            )

            // 3. Menghubungkan Relasi Memori ke Tempat Masing-masing
            memory1.place = bali
            memory4.place = bali
            memory9.place = bali
            
            memory2.place = kyoto
            memory8.place = kyoto
            
            memory3.place = tokyo
            memory7.place = tokyo
            
            memory5.place = hallstatt
            memory6.place = santorini
            
            // 4. Memasukkan Seluruh Memori ke Database Tiruan
            context.insert(memory1)
            context.insert(memory2)
            context.insert(memory3)
            context.insert(memory4)
            context.insert(memory5)
            context.insert(memory6)
            context.insert(memory7)
            context.insert(memory8)
            context.insert(memory9)
            
            return container
        } catch {
            fatalError("Gagal membuat preview container: \(error)")
        }
    }()
}
