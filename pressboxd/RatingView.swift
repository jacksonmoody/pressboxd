//
//  RatingView.swift
//  pressboxd
//
//  Created by Jackson Moody on 6/26/24.
//

import SwiftUI

struct RatingView: View {
    
    @Binding var rating: Int
    @Binding var liked: Bool
    
    var maximumRating = 5
    
    var onImage = Image(systemName: "star.fill").resizable()
    var heartImage = Image(systemName: "heart.fill").resizable()
    
    var offColor = Color.gray
    var onColor = Color("AccentColor")
    var likeColor = Color("SecondaryColor")
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text("Rated")
                    .font(.custom("Play", size: 16))
                    .foregroundColor(Color("TextColor"))
                HStack{
                    ForEach(1..<maximumRating + 1, id: \.self) { number in
                        Button {
                            rating = number
                        } label: {
                            onImage
                                .foregroundStyle(number > rating ? offColor : onColor)
                                .frame(width: 35, height: 35)
                        }
                    }
                }
            }
            Spacer()
            VStack {
                Text("Liked")
                    .font(.custom("Play", size: 16))
                    .foregroundColor(Color("TextColor"))
                Button {
                    liked.toggle()
                } label: {
                    heartImage
                        .foregroundStyle(liked ? likeColor : offColor)
                        .frame(width: 35, height: 33)
                }
            }
        }.buttonStyle(.plain)
    }
}

#Preview {
    RatingView(rating: .constant(4), liked: .constant(true))
}
