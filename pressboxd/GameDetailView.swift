//
//  GameDetailView.swift
//  pressboxd
//
//  Created by Jackson Moody on 7/14/24.
//

import SwiftUI

struct GameDetailView: View {
    
    @State var reviews: [Review] = []
    let game: Game
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack(alignment:.leading) {
                ReviewChartView(reviews:reviews)
                    .frame(height:250)
            }
        }.navigationTitle(game.gameName ?? "")
            .task{
                await getReviewCounts()
            }
    }
    
    func getReviewCounts() async {
        do {
            reviews = try await supabase
                .from("reviews")
                .select()
                .eq("game", value: game.id)
                .execute()
                .value
            
        } catch {
            debugPrint(error)
        }
    }
}

#Preview {
    GameDetailView(game:Game(id: UUID(uuidString: "33fc3cb2-6904-4e9b-89b5-1a737d2deb4a")!, sport: "baseball", league: "mlb", timeZone: nil, date: nil, startTime: nil, gameName: "test", homeTeam:nil, awayTeam:nil, featureTag: "Regular"))
}
