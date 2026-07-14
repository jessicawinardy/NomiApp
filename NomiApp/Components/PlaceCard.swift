import SwiftUI

struct PlaceCard: View {
    let place: Place
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var latestPlaceImage: UIImage {
        let allMemories = place.memories ?? []

        let latestMemory = allMemories.sorted(by: {
            $0.date > $1.date
        }).first(where: {
            $0.imageData != nil
        })

        if let data = latestMemory?.imageData, let uiImage = UIImage(data: data) {
            return uiImage
        }

        return UIImage(resource: .image)
    }

    private var cardMinHeight: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 230 : 200
    }

    var body: some View {
        NavigationLink(value: ContentView.Route.place(place)) {
            VStack(alignment: .leading, spacing: 4) {
                Spacer()

                Text(place.name)
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                HStack(spacing: 2) {
                    HStack(spacing: 2) {
                        Image(systemName: "mappin")
                        Text(place.country)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }

                    Text("·")

                    Text("\(place.memoryCount) Memories")
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
                .font(.caption.weight(.medium))
                .foregroundColor(.white.opacity(0.7))
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: cardMinHeight, alignment: .bottomLeading)
            .background {
                Image(uiImage: latestPlaceImage)
                    .resizable()
                    .scaledToFill()
                    .overlay {
                        LinearGradient(
                            colors: [
                                .clear,
                                .black.opacity(0.2),
                                .black.opacity(0.55)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(
                color: .black.opacity(0.2),
                radius: 5,
                x: 3,
                y: 3
            )
        }
    }
}


#Preview {
    PlaceCard(place: Place(name: "Kyoto", country: "Japan", imageName: "image"))
}
