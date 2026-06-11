//
//  ContentView.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 10/06/26.
//

import SwiftUI
//import SwiftData

struct ContentView: View {
    let dummyMemories: [Memory] = [
        Memory(
            location: "Ubud, Bali",
            title: "Morning walk through the rice terraces. The mist was still low on the fields.",
            date: Calendar.current.date(
                from: DateComponents(year: 2028, month: 6, day: 8, hour: 7, minute: 23)
            ) ?? .now,
            mood: .peaceful
        ),

        Memory(
            location: "Gion District, Kyoto",
            title: "Walked through hidden streets and discovered a quiet cafe filled with cookies.",
            date: Calendar.current.date(
                from: DateComponents(year: 2028, month: 6, day: 12, hour: 10, minute: 15)
            ) ?? .now,
            mood: .adventurous
        ),

        Memory(
            location: "Shibuya, Tokyo",
            title: "Crossed the famous intersection and watched the city come alive at night.",
            date: Calendar.current.date(
                from: DateComponents(year: 2028, month: 6, day: 15, hour: 20, minute: 45)
            ) ?? .now,
            mood: .excited
        ),

        Memory(
            location: "Nusa Penida, Bali",
            title: "Spent the afternoon by the cliffs and watched the waves crash below.",
            date: Calendar.current.date(
                from: DateComponents(year: 2028, month: 6, day: 20, hour: 16, minute: 30)
            ) ?? .now,
            mood: .amazing
        ),

        Memory(
            location: "Hallstatt, Austria",
            title: "The village looked exactly like a postcard covered in soft morning light.",
            date: Calendar.current.date(
                from: DateComponents(year: 2028, month: 7, day: 2, hour: 8, minute: 10)
            ) ?? .now,
            mood: .tired
        ),

        Memory(
            location: "Santorini, Greece",
            title: "Watched the sunset paint the white buildings in shades of orange and pink.",
            date: Calendar.current.date(
                from: DateComponents(year: 2028, month: 7, day: 8, hour: 19, minute: 5)
            ) ?? .now,
            mood: .emotional
        )
    ]
    var body: some View {
        VStack (alignment: .leading, spacing: 15){
            HStack{
                Text("Journal")
                    .font(.system(size: 36, weight: .bold))
                Spacer()
                Image(.image)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
//                    .overlay(
//                            Circle()
//                                .stroke(.white, lineWidth: 2)
//                        )
                    .shadow(radius: 4)
            }
            
            Text("TODAY'S SNAPSHOT")
                .font(Font.system(size: 11, weight: .bold))
                .foregroundColor(.greyAccent)
            
            TodayCard(memory: Memory(
                location: "Ubud, Bali",
                title: "Morning walk through the rice terraces. Them mist was still lown on the fields.",
                date: .now,
                mood: .peaceful
                )
            )
            HStack{
                Text("RECENT MEMORIES")
                    .font(Font.system(size: 11, weight: .bold))
                    .foregroundColor(.greyAccent)
                Spacer()
                Text("See All")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.blueAccent)
            }
            LazyVStack(spacing: 15){
                
                ForEach(dummyMemories.indices, id: \.self){ index in
                    MemoryCard(memory:dummyMemories[index])
                    
                    if index < dummyMemories.count - 1 {
                        Divider()
                            .overlay(.gray.opacity(0.2))
                    }
                }
            }
        }
        .padding(28)
    }
}

#Preview {
    ContentView()
}
