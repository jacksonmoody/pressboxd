//
//  OnboardingView.swift
//  pressboxd
//
//  Created by Jackson Moody on 6/22/24.
//

import PhotosUI
import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboarded:Bool
    
    @State private var username = ""
    @State private var fullName = ""
    @State private var description = ""
    
    @State private var imageSelection: PhotosPickerItem?
    @State private var profileImage: CustomImage?
    
    @State private var isLoading = false
    @State private var didError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack{
                VStack(alignment: .center) {
                    Text("Welcome to Pressboxd!")
                        .font(.custom("Play-Bold", size: 30))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("TextColor"))
                        .padding(.top, 30.0)
                    
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
                        PhotosPicker(selection: $imageSelection, matching: .images) {
                            Text("Add a Profile Picture")
                                .font(.custom("Play-Regular", size: 17))
                                .frame(maxWidth: 180, maxHeight: 40)
                                .foregroundColor(Color("BackgroundColor"))
                                .background(Color("PrimaryColor"))
                                .cornerRadius(10)
                                .padding(.top, 15)
                        }
                    }
                    .onChange(of: imageSelection) { _, newValue in
                        guard let newValue else { return }
                        loadTransferable(from: newValue)
                    }
                }
                VStack(alignment: .leading) {
                    Text("What is your full name?")
                        .foregroundColor(Color("TextColor"))
                        .font(.custom("Play-Regular", size: 20))
                        .padding(.vertical, 10)
                    TextField("Full Name", text: $fullName, prompt: Text(""))
                        .textContentType(.name)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)
                        .padding(10.0)
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color("TextColor")))
                        .foregroundColor(.black)
                        .font(.custom("Play-Regular", size: 20))
                    
                    Text("Enter a unique username:")
                        .foregroundColor(Color("TextColor"))
                        .font(.custom("Play-Regular", size: 20))
                        .padding(.vertical, 10)
                    TextField("Username", text: $username, prompt: Text(""))
                        .textContentType(.username)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding(10.0)
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color("TextColor")))
                        .foregroundColor(.black)
                        .font(.custom("Play-Regular", size: 20))
                    
                    Text("Tell us about yourself:")
                        .foregroundColor(Color("TextColor"))
                        .font(.custom("Play-Regular", size: 20))
                        .padding(.vertical, 10)
                    TextEditor(text: $description)
                        .textContentType(.name)
                        .autocorrectionDisabled()
                        .padding(10.0)
                        .font(.custom("Play-Regular", size: 20))
                        .scrollContentBackground(.hidden)
                        .foregroundColor(.black)
                        .background(Color("TextColor"))
                        .cornerRadius(10.0)
                }
                .padding(20)
                Button(action:submitOnboarding) {
                    Text("Submit")
                        .font(.custom("Play-Bold", size: 20))
                        .frame(maxWidth: 180, maxHeight: 40)
                        .foregroundColor(Color("BackgroundColor"))
                        .background(Color("PrimaryColor"))
                        .cornerRadius(10)
                }
                .disabled(isLoading)
                if isLoading {
                    ProgressView()
                }
                Spacer()
            }
        }.alert(
            "Error",
            isPresented: $didError
        ) {
            Button("OK") {
                withAnimation {
                    isLoading = false
                }
            }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) {
        Task {
            do {
                profileImage = try await imageSelection.loadTransferable(type: CustomImage.self)
            }
        }
    }
    
    func submitOnboarding() {
        if (username.isEmpty || fullName.isEmpty) {
            didError = true
            errorMessage = "Name and username are required"
        }
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                let imageURL = try await uploadImage(profileImage:profileImage)
                
                let currentUser = try await supabase.auth.session.user
                let profile = Profile(id: currentUser.id, username: username, fullName:fullName, bio:description, profileURL: imageURL, onboarded: true)
                
                try await supabase
                    .from("users")
                    .insert(profile)
                    .execute()
                
                isOnboarded=true
                
            } catch {
                didError = true
                errorMessage = "Error creating user. Please try again with another username."
                debugPrint(error)
            }
        }
        
    }
}

#Preview {
    struct Preview: View {
        @State var isShowingOnboarding = true
        var body: some View {
            OnboardingView(isOnboarded: $isShowingOnboarding)
        }
    }
    return Preview()
}
