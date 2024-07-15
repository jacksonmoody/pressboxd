//
//  GameViewSmall.swift
//  pressboxd
//
//  Created by Jackson Moody on 7/14/24.
//

import SwiftUI

struct GameViewSmall: View {
    
    let gameName: String?
    let date: String?
    let team1: String?
    let team2: String?
    let gameLogoUrl: String?
    @State var logoImage: CustomImage?
    
    var body: some View {
        VStack {
            Group {
                if let logoImage {
                    logoImage.image
                        .resizable()
                        .frame(width: 100, height:100)
                } else {
                    Image(systemName: "figure.baseball")
                        .symbolRenderingMode(.multicolor)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height:80)
                        .foregroundColor(.gray)
                }
            }
            Text((team1 ?? "") + " @")
                .foregroundColor(Color("TextColor"))
                .font(.footnote)
            Text(team2 ?? "")
                .font(.footnote)
                .foregroundColor(Color("TextColor"))
            
        }.task {
            await getLogo()
        }
    }
    
    func getLogo() async {
        do {
            if (gameLogoUrl != nil) {
                logoImage = try await downloadImage(path: gameLogoUrl!, database:"logos")
            }
        } catch {
            debugPrint(error)
        }
    }
}
