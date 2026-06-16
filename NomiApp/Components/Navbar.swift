//
//  Navbar.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 11/06/26.
//

import SwiftUI

struct Navbar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        
    }
}

#Preview {
    Navbar(selectedTab: .constant(.journal))
}
