//
//  Mood.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 10/06/26.
//

import SwiftUI

enum Mood: String, Codable, CaseIterable {
    case amazing
    case peaceful
    case excited
    case emotional
    case tired
    case adventurous
}

extension Mood {
    var icon: String {
        switch self {
        case .amazing:
            return "star.fill"
        case .peaceful:
            return "leaf.fill"
        case .excited:
            return "sparkles"
        case .emotional:
            return "heart.fill"
        case .tired:
            return "moon.fill"
        case .adventurous:
            return "map.fill"
        }
    }

    var title: String {
        switch self {
        case .amazing:
            return "Amazing"
        case .peaceful:
            return "Peaceful"
        case .excited:
            return "Exciting"
        case .emotional:
            return "Emotional"
        case .tired:
            return "Tired"
        case .adventurous:
            return "Adventurous"
        }
    }
}
