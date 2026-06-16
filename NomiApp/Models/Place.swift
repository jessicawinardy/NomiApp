//
//  Memory.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 10/06/26.
//

import Foundation
import SwiftData

@Model
class Place {
    @Attribute(.unique) var id: UUID
    var name: String
    var country: String
    var imageName: String
    
    @Relationship(deleteRule: .cascade, inverse: \Memory.place)
    var memories: [Memory]? = []
    
    var memoryCount: Int {
        memories?.count ?? 0
    }
    
    init(id: UUID = UUID(), name: String, country: String, imageName: String) {
        self.id = id
        self.name = name
        self.country = country
        self.imageName = imageName
        self.memories = []
    }
}
