//
//  MemoryCard.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 10/06/26.
//

import SwiftUI

struct MemoryCard: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(.image)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            VStack(alignment: .leading, spacing: 6) {

                HStack(spacing: 2) {
                    Image(systemName: "mappin")
                    Text("Gion District, Kyoto")
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color.orange)

                Text(
                    "Walked through hidden streets and discovered a quiet cafe filled with cookies."
                )
                .font(.system(size: 13, weight: .medium))
                .lineLimit(3)

                HStack(spacing: 8) {
                    Text("June 8, 2026")

                    Text("·")

                    HStack(spacing: 2) {
                        Image(systemName: "leaf.fill")
                        Text("Peaceful")
                    }
                }
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}

#Preview {
    MemoryCard()
}
