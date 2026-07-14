//
//  ContentView.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 10/06/26.
//

import SwiftUI
import SwiftData

struct JournalView: View {
    @Query(sort: \Memory.date, order: .reverse) private var memories: [Memory]
    
    private var recentMemories: [Memory] {
            Array(memories.prefix(5))
        }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Journal")
                    .font(.custom("PlayfairDisplay-Bold", size: 36))
                    .fontWeight(.bold)
                
                Spacer()
                
//                Image(.image)
//                    .resizable()
//                    .frame(width: 40, height: 40)
//                    .clipShape(Circle())
//                    .shadow(radius: 4)
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("TODAY'S SNAPSHOT")
                        .font(Font.system(size: 11, weight: .bold))
                        .foregroundColor(.greyAccent)
                        .tracking(1)
                    
                    if let todayMemory = memories.first(where: { Calendar.current.isDateInToday($0.date) }) {
                        TodayCard(memory: todayMemory)
                    }
                    else {
                        VStack(spacing: 8) {
                            Text("No snapshot today")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Go outside and snap a memory")
                                .font(.system(size: 14))
                                .foregroundColor(.greyAccent)
                            }
                        .frame(maxWidth: .infinity, minHeight: 240)
                        .padding(.horizontal, 28)
                    }
                    
                    HStack {
                        Text("RECENT MEMORIES")
                            .font(Font.system(size: 11, weight: .bold))
                            .foregroundColor(.greyAccent)
                            .tracking(1)
                        
                        Spacer()
//                            
//                            Text("See All")
//                                .font(.system(size: 11, weight: .bold))
//                                .foregroundColor(.blueAccent)
                    }
                    
                    LazyVStack(spacing: 15) {
                        ForEach(recentMemories) { memory in
                            MemoryCard(memory: memory)

                            if memory != recentMemories.last{
                                Divider()
                                    .overlay(.gray.opacity(0.2))
                            }
                        }
                        Spacer()
                    }
                    
                }
            }
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 64)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    JournalView()
        .modelContainer(SampleData.previewContainer)
}
