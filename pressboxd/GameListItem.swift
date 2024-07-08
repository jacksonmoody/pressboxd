//
//  GameListItem.swift
//  pressboxd
//
//  Created by Jackson Moody on 7/7/24.
//

import SwiftUI

struct GameListItem: View {
    @State var name: String
    @State var date: String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(name)
                .foregroundColor(Color("TextColor"))
            Text(date)
                .font(.footnote)
                .foregroundColor(Color("TextColor"))
                .padding(.top, 1.0)
            
        }
    }
}

#Preview {
    GameListItem(name:"Test", date: "Test")
}
