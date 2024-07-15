//
//  AddReview.swift
//  pressboxd
//
//  Created by Amy Dong on 7/14/24.
//

import SwiftUI

struct OtherUserProfileView: View {
    @Binding var isShowingProfile: Bool
    @State var isFollowing: Bool
    @State var selectedUser:User?
    @State var profileImage: ProfileImage?
    
    var body: some View {
        let fullName = selectedUser?.fullName ?? ""
        let username = selectedUser?.username ?? ""
        let description = selectedUser?.bio ?? ""
        let following = selectedUser?.following
        let followers = selectedUser?.followers
        
        Group {
            if selectedUser != nil {
                ZStack {
                    Color("BackgroundColor").ignoresSafeArea()
                    VStack(alignment: .leading) {
                        
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
                        
                        VStack{
                            
                            Text(description)
                                .font(.custom("Play", size: 20))
                                .foregroundColor(Color("TextColor"))
                                .padding(.top,10)
                            
                            Button(action: {
                                Task{await FollowProcedure()}
                            }){
                                Text(isFollowing ? "Following" : "Follow")
                                    .padding(.all, 10)
                                    .background(isFollowing ? Color("BackgroundColor") : Color("PrimaryColor"))
                                    .foregroundColor(isFollowing ? Color("PrimaryColor") : Color("BackgroundColor"))
                                    .cornerRadius(5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius : 5).stroke(Color("PrimaryColor"), lineWidth : 2))
                            }
                        }.frame(maxWidth: .infinity, alignment: .center)
                        
                        HStack {
                            VStack{
                                Text(String(following!.count))
                                    .font(.custom("Play", size: 20))
                                    .foregroundColor(Color("TextColor"))
                                    .padding(.top,10)
                                Text("Following")
                                    .font(.custom("Play", size: 20))
                                    .foregroundColor(Color("TextColor"))
                            }
                            
                            VStack{
                                Text(String(followers!.count))
                                    .font(.custom("Play", size: 20))
                                    .foregroundColor(Color("TextColor"))
                                    .padding(.top,10)
                                Text("Followers")
                                    .font(.custom("Play", size: 20))
                                    .foregroundColor(Color("TextColor"))
                            }
                            
                        }.frame(maxWidth: .infinity, alignment: .center)
                        
                        
                        Spacer()
                    }.padding([.top, .leading, .trailing], 20.0)
                }
            } else {
                UserListView(selectedUser:$selectedUser)
            }
        }
    }
    
    func FollowProcedure() async {
        do{
            let currentUser = try await supabase.auth.session.user
            
            if isFollowing {
                print("unfollow")
            }
            else{
                let currentFollowing = try await supabase.from("users").select("following").eq("id", value : currentUser.id)
                print(currentFollowing)
            }
        } catch {
            print("ew")
            debugPrint(error)
        }
        
        isFollowing.toggle()
    }
    
}

#Preview {
    struct Preview: View {
        @State var isShowingProfile = true
        @State var isFollowing = false
        var body: some View {
            OtherUserProfileView(isShowingProfile: $isShowingProfile, isFollowing: isFollowing)
        }
    }
    return Preview()
}
