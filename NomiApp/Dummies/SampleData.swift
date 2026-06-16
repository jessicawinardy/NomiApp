import Foundation
import SwiftData
import UIKit

@MainActor
struct SampleData {

    static let previewContainer: ModelContainer = {
        do {
            let schema = Schema([Place.self, Memory.self])
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: schema, configurations: [configuration])
            
            
            insertSampleData(into: container.mainContext)
            
            return container
        } catch {
            fatalError("Gagal membuat preview container: \(error)")
        }
    }()
  
    static func insertSampleData(into context: ModelContext) {
        let dummyImageData = UIImage(resource: .image).jpegData(compressionQuality: 0.8)
        
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
        
        let memory1 = Memory(location: "Ubud", title: "Morning walk through the rice terraces. The mist was still low on the fields.", date: .now, mood: .peaceful, liked: true, imageData: dummyImageData)
        let memory2 = Memory(location: "Gion District", title: "Walked through hidden streets and discovered a quiet cafe filled with cookies.", date: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 12)) ?? .now, mood: .adventurous, liked: false, imageData: dummyImageData)
        let memory3 = Memory(location: "Shibuya", title: "Crossed the famous intersection and watched the city come alive at night.", date: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 11)) ?? .now, mood: .excited, liked: true, imageData: dummyImageData)
        let memory4 = Memory(location: "Nusa Penida", title: "Spent the afternoon by the cliffs and watched the crystal clear waves crash below.", date: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 10)) ?? .now, mood: .amazing, liked: false, imageData: dummyImageData)
        let memory5 = Memory(location: "Lake Hallstatt", title: "The village looked exactly like a postcard covered in soft, golden morning light.", date: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 8)) ?? .now, mood: .peaceful, liked: true, imageData: dummyImageData)
        let memory6 = Memory(location: "Oia", title: "Watched the iconic sunset paint the white buildings in shades of orange and pink.", date: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 5)) ?? .now, mood: .emotional, liked: false, imageData: dummyImageData)
        let memory7 = Memory(location: "Akihabara", title: "Explored retro arcade buildings and found some rare vintage game soundtracks.", date: Calendar.current.date(from: DateComponents(year: 2026, month: 6, day: 3)) ?? .now, mood: .excited, liked: false, imageData: dummyImageData)
        let memory8 = Memory(location: "Fushimi Inari", title: "Hiked up through thousands of red Torii gates before the afternoon crowd arrived.", date: Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 28)) ?? .now, mood: .adventurous, liked: true, imageData: dummyImageData)
        let memory9 = Memory(location: "Seminyak", title: "Caught a heavy downpour inside a cozy coffee shop. Just listening to the rain.", date: Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 25)) ?? .now, mood: .tired, liked: false, imageData: dummyImageData)

        memory1.place = bali
        memory4.place = bali
        memory9.place = bali
        memory2.place = kyoto
        memory8.place = kyoto
        memory3.place = tokyo
        memory7.place = tokyo
        memory5.place = hallstatt
        memory6.place = santorini
        
        context.insert(memory1)
        context.insert(memory2)
        context.insert(memory3)
        context.insert(memory4)
        context.insert(memory5)
        context.insert(memory6)
        context.insert(memory7)
        context.insert(memory8)
        context.insert(memory9)
    }
}
