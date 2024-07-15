//
//  UserListView.swift
//  pressboxd
//
//  Created by Amy Dong on 7/14/24.
//

import SwiftUI

struct UserListView: View {
    
    @Binding var selectedUser:User?
    @State var users:[User] = []
    @State var searchText = ""
    
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack(alignment: .leading) {
                Text("Search Users")
                    .font(.custom("Play-Bold", size: 40))
                    .foregroundColor(Color("TextColor"))
                    .padding(.leading, 20.0)
                    .padding(.bottom, 5.0)
                SearchBar(text:$searchText, placeholder:"Search")
                    .padding(.horizontal, 10.0)
                
                List(searchResults, id: \.self, selection: $selectedUser) {
                    user in
                    GameListItem(name: user.fullName!, date: "@" + user.username!).listRowBackground(Color.clear)
                }
                .padding(.horizontal, 10.0)
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
            }
        }.task {
            await getUsers()
        }
    }
    
    var searchResults: [User] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { $0.username!.localizedStandardContains(searchText) }
        }
    }
    
    func getUsers() async {
        do {
            users = try await supabase
                .from("users")
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
        @State var selectedUser:User? = nil
        var body: some View {
            UserListView(selectedUser: $selectedUser)
        }
    }
    return Preview()
}
