//
//  HomeView.swift
//  pressboxd
//
//  Created by Jackson Moody on 6/23/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack {
                HStack {
                    Text("Pressboxd")
                        .font(.custom("Play-Bold", size: 40))
                        .padding([.top, .leading, .bottom], 20.0)
                        .foregroundColor(Color("TextColor"))
                    Image("Logo")
                        .resizable()
                        .frame(width: 50.0, height: 50.0)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
        }
    }
}

#Preview {
    HomeView()
}
