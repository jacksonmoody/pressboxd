//
//  HomeView.swift
//  pressboxd
//
//  Created by Jackson Moody on 6/22/24.
//

import SwiftUI

struct NavbarView: View {
    
    @State private var selection = 0
    @State private var isShowingReview = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selection) {
                Group {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            .padding(.top, 50.0)
                        }
                        .tag(0)
                    
                    Spacer()
                        .tabItem {
                            EmptyView()
                        }
                        .tag(1)
                    
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.crop.circle.fill")
                                .padding(.top, 50.0)
                        }
                        .tag(2)
                    
                }   
                    .toolbarBackground(Color("BackgroundColor"), for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
            }
            Button {
                isShowingReview = true
            } label: {
                Image(systemName: "plus")
                    .padding(.top, 10.0)
                    .tint(Color("BackgroundColor"))
                
            }
            .frame(width: 40, height: 40)
            .padding(.bottom, 10.0)
            .background(Color("AccentColor"))
            .clipShape(Circle())
            
        }
        .ignoresSafeArea(.keyboard)
        .onChange(of: selection) {
            if selection == 1 {
                self.selection = selection
            }
        }
        .sheet(isPresented: $isShowingReview) {
            AddReview(isShowingReview: $isShowingReview)
        }
    }
}

#Preview {
    NavbarView()
}
