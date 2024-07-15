//
//  HomeView.swift
//  pressboxd
//
//  Created by Jackson Moody on 6/23/24.
//

import SwiftUI

struct HomeView: View {
    @State var games:[Game] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()
                VStack(alignment:.leading) {
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
                    Text("Popular Now")
                        .font(.custom("Play-Bold", size: 25))
                        .foregroundColor(Color("TextColor"))
                        .padding(.leading, 20.0)
                    ScrollView(.horizontal, content: {
                        HStack(spacing: 15) {
                            ForEach(games, id: \.id) { game in
                                NavigationLink { GameDetailView(game:game)} label: { GameViewSmall(gameName: game.gameName, date: game.date, team1: game.homeTeam?.teamName, team2: game.awayTeam?.teamName, gameLogoUrl: game.homeTeam?.logo)}
                            }
                        }
                        .padding(.top, 25)
                    })
                    .padding([.top, .leading], 20.0)
                    .frame(height: 100)
                    Spacer()
                }
            }
        }.task {
            await getGames()
        }
    }
    
    func getGames() async {
        do {
            games = try await supabase
                .from("games")
                .select("id, game_name, date, home_team(*), away_team(*)")
                .order("date", ascending: false)
                .limit(10)
                .execute()
                .value
            
        } catch {
            debugPrint(error)
        }
    }
}

#Preview {
    HomeView()
}
