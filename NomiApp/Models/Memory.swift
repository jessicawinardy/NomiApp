//
//  Memory.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 10/06/26.
//

import Foundation
import SwiftData

@Model
class Memory: Identifiable {
    @Attribute(.unique) var id: UUID
    var location: String
    var title: String
    var date: Date
    var mood: Mood
    var liked: Bool
    
    var place: Place?
    
    @Attribute(.externalStorage) var imageData: Data?
    
    init (id: UUID = UUID(), location: String, title: String, date: Date, mood: Mood, liked: Bool, imageData: Data? = nil) {
        self.id = id
        self.location = location
        self.title = title
        self.date = date
        self.mood = mood
        self.liked = liked
        self.imageData = imageData
    }
    
   var displayLocation: String {
            let cityName = place?.name ?? ""
            let specificSpot = location
            
            if !specificSpot.isEmpty && !cityName.isEmpty {
                return "\(specificSpot), \(cityName)"
            } else if !cityName.isEmpty {
                return cityName
            } else {
                return specificSpot.isEmpty ? "Unknown Location" : specificSpot
            }
        }
}
