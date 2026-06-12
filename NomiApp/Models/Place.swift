//
//  Memory.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 10/06/26.
//

import Foundation

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let country: String
    let memoryCount: Int
    let imageName: String
}
