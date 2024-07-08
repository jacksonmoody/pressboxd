//
//  GameListView.swift
//  pressboxd
//
//  Created by Jackson Moody on 7/7/24.
//

import SwiftUI

struct GameListView: View {
    
    @Binding var selectedGame:Game?
    @State var games:[Game] = []
    @State var searchText = ""
    
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack(alignment: .leading) {
                Text("Add Review")
                    .font(.custom("Play-Bold", size: 40))
                    .foregroundColor(Color("TextColor"))
                    .padding(.leading, 20.0)
                    .padding(.bottom, 5.0)
                SearchBar(text:$searchText, placeholder:"Search")
                    .padding(.horizontal, 10.0)
                
                List(searchResults, id: \.self, selection: $selectedGame) {
                    game in
                    GameListItem(name: game.gameName, date: game.date)                .listRowBackground(Color.clear)
                }
                .padding(.horizontal, 10.0)
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
            }
        }.task {
            await getGames()
        }
    }
    
    var searchResults: [Game] {
        if searchText.isEmpty {
            return games
        } else {
            return games.filter { $0.gameName.localizedStandardContains(searchText) }
        }
    }
    
    func getGames() async {
        do {
            games = try await supabase
                .from("games")
                .select()
                .execute()
                .value
            
        } catch {
            debugPrint(error)
        }
    }
}

#Preview {
    struct Preview: View {
        @State var selectedGame:Game? = nil
        var body: some View {
            GameListView(selectedGame: $selectedGame)
        }
    }
    return Preview()
}
