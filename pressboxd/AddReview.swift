//
//  AddReview.swift
//  pressboxd
//
//  Created by Jackson Moody on 6/22/24.
//

import SwiftUI

struct AddReview: View {
    @Binding var isShowingReview: Bool
    @State var rating = 0
    @State var liked = false
    @State var review = ""
    @State var selectedGame:Game?
    @State var selectedTeam: String?
    @State var isLoading = false
    
    var body: some View {
        
        let teamOptions = [selectedGame?.homeTeam?.teamName ?? "", selectedGame?.awayTeam?.teamName ?? "", "Neither"]
        
        Group {
            if selectedGame != nil {
                ZStack {
                    Color("BackgroundColor").ignoresSafeArea()
                    VStack(alignment: .leading) {
                        Text("Add Review")
                            .font(.custom("Play-Bold", size: 40))
                            .foregroundColor(Color("TextColor"))
                            .padding(.bottom, 10.0)
                        
                        Text(selectedGame?.gameName ?? "")
                            .font(.custom("Play-Bold", size: 20))
                            .foregroundColor(Color("TextColor"))
                            .padding(.bottom, 20.0)
                        
                        RatingView(rating:$rating, liked:$liked)
                        
                        Divider()
                            .padding(.vertical, 10.0)
                        
                        DatePicker(selection: /*@START_MENU_TOKEN@*/.constant(Date())/*@END_MENU_TOKEN@*/, displayedComponents: [.date], label: { Text("Date Watched:") })
                        
                        List {
                            Picker("Which team were you rooting for?", selection: $selectedTeam) {
                                ForEach(0 ..< teamOptions.count, id: \.self) { index in
                                    Text(teamOptions[index]).tag(teamOptions[index] as String?)
                                }
                            }
                            .padding(.top, 20.0)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.plain)
                        .frame(height:70)
                        
                        Text("What did you think?")
                            .foregroundColor(Color("TextColor"))
                            .font(.custom("Play-Regular", size: 20))
                            .padding(.vertical, 10)
                        TextEditor(text: $review)
                            .padding(10.0)
                            .font(.custom("Play-Regular", size: 20))
                            .scrollContentBackground(.hidden)
                            .foregroundColor(.black)
                            .background(Color("TextColor"))
                            .cornerRadius(10.0)
                        
                        Button(action:AddReview) {
                            Text("Submit")
                                .font(.custom("Play-Bold", size: 20))
                                .frame(maxWidth: 180, maxHeight: 40)
                                .foregroundColor(Color("BackgroundColor"))
                                .background(Color("PrimaryColor"))
                                .cornerRadius(10)
                        }
                        .padding(.vertical, 20.0)
                        .frame(maxWidth:.infinity, alignment:.center)
                        
                        Spacer()
                    }.padding([.top, .leading, .trailing], 20.0)
                }
            } else {
                GameListView(selectedGame:$selectedGame)
            }
        }
    }
    
    private func AddReview() {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                let currentUser = try await supabase.auth.session.user
                let review = Review(id: UUID(), userId: currentUser.id, game: selectedGame?.id ?? selectedGame?.homeTeam?.id, rating: rating, liked: liked, review: review, rootingFor: selectedTeam ?? "Neither")
                
                try await supabase
                    .from("reviews")
                    .insert(review)
                    .execute()
                
                isShowingReview.toggle()
                
            } catch {
                debugPrint(error)
            }
        }
    }
    
}

#Preview {
    struct Preview: View {
        @State var isShowingReview = true
        var body: some View {
            AddReview(isShowingReview: $isShowingReview)
        }
    }
    return Preview()
}
