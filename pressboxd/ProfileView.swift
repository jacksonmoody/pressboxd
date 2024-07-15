//
//  ProfileView.swift
//  pressboxd
//
//  Created by Jackson Moody on 6/23/24.
//

import SwiftUI

struct ProfileView: View {
    
    @State var username = ""
    @State var fullName = ""
    @State var description = ""
    @State var profileImage: CustomImage?
    @State var following = []
    @State var followers = []
    
    
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack(alignment: .leading){
                HStack {
                    Group {
                        if let profileImage {
                            profileImage.image
                                .resizable()
                                .frame(width: 100, height:100)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .symbolRenderingMode(.multicolor)
                                .resizable()
                                .frame(width: 100, height:100)
                                .foregroundColor(.gray)
                        }
                    }
                    VStack{
                        Text(fullName)
                            .font(.custom("Play-Bold", size: 32))
                            .foregroundColor(Color("TextColor"))
                            .padding(.leading, 20.0)
                            .frame(width: 150)
                            .padding(.bottom, 1)
                        Text("@\(username)")
                            .font(.custom("Play-Regular", size: 15))
                            .foregroundColor(Color.gray)
                            .frame(width: 150)
                    }
                }.frame(maxWidth: .infinity, alignment: .center)
    
                HStack {
                    VStack{
                        Text(String(following.count))
                            .font(.custom("Play", size: 20))
                            .foregroundColor(Color("TextColor"))
                            .padding(.top,10)
                        Text("Following")
                            .font(.custom("Play", size: 20))
                            .foregroundColor(Color("TextColor"))
                    }
                    
                    VStack{
                        Text(String(followers.count))
                            .font(.custom("Play", size: 20))
                            .foregroundColor(Color("TextColor"))
                            .padding(.top,10)
                        Text("Followers")
                            .font(.custom("Play", size: 20))
                            .foregroundColor(Color("TextColor"))
                    }
                    
                }.frame(maxWidth: .infinity, alignment: .center)
                
                VStack{
                    Text(description)
                        .font(.custom("Play", size: 20))
                        .foregroundColor(Color("TextColor"))
                        .padding(.top,10)
                    Button("Logout", action:Logout)
                        .padding(.top, 5.0)
                }.frame(maxWidth: .infinity, alignment: .center)
                
                Text("Favorites")
                    .font(.custom("Play-Bold", size: 32))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color("TextColor"))
                    .padding(.top, 20)
                    .padding(.leading, 15)
                
                Text("Recents")
                    .font(.custom("Play-Bold", size: 32))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color("TextColor"))
                    .padding(.leading, 15)
                
                Spacer()
            }
            .padding(.top, 20.0)

        }.task {
            await getProfile()
        }
    }
    
    func getProfile() async {
        do {
            let currentUser = try await supabase.auth.session.user
            
            let profile: Profile = try await supabase
                .from("users")
                .select()
                .eq("id", value: currentUser.id)
                .single()
                .execute()
                .value
            
            username = profile.username ?? ""
            fullName = profile.fullName ?? ""
            description = profile.bio ?? ""
            following = profile.following
            followers = profile.followers
        
            
            if let profileURL = profile.profileURL, !profileURL.isEmpty {
                profileImage = try await downloadImage(path: profileURL, database:"photos")
            }
            
        } catch {
            debugPrint(error)
        }
    }
}

func Logout() {
    Task {
        do {
            try await supabase.auth.signOut()
        } catch let error {
            print(error)
        }
    }
}

#Preview {
    ProfileView(username:"testperson", fullName:"Test Person", description: "Hi! My name is Test Person.")
}
