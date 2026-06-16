import SwiftUI

struct PlaceCard: View {
    let place: Place

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Spacer()
            
            Text(place.name)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)

            HStack(spacing: 2) {
                HStack(spacing: 2) {
                    Image(systemName: "mappin")
                    Text(place.country)
                }

                Text("·")

                Text("\(place.memoryCount) Memories")
            }
            .font(.system(size: 10, weight: .medium))
            .foregroundColor(.white.opacity(0.7))
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 200, alignment: .bottomLeading)
        .background {
            Image(.image)
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


#Preview {
    PlaceCard(place: Place(name: "Kyoto", country: "Japan", imageName: "image"))
}
