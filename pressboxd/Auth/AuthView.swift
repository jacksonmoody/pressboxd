//
//  AuthView.swift
//  pressboxd
//
//  Created by Jackson Moody on 6/22/24.
//

import SwiftUI
import Supabase

struct AuthView: View {
  @State var phone = ""
  @State var verificationCode = ""
  @State var errorText = ""
  @State var buttonText = "Sign In"
  @State var isLoading = false
  @State var verification: Result<Void, Error>?
  @State var step = 1
  
  var body: some View {
    ZStack {
      Color("BackgroundColor").ignoresSafeArea()
      VStack(alignment: .leading) {
        Text("Login to Pressboxd")
          .font(.custom("Play-Bold", size: 30))
          .padding(.top, 20)
          .padding(.bottom, 10)
          .foregroundColor(Color("TextColor"))
        Text("Enter your phone number below to get started.")
          .foregroundColor(Color("TextColor"))
          .padding(.bottom, 50.0)
          .font(.custom("Play-Regular", size: 20))
        TextField("Phone Number", text: $phone, prompt: Text(""))
          .textContentType(.telephoneNumber)
          .keyboardType(.numberPad)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled()
          .font(.custom("Play-Regular", size: 50))
          .padding(.horizontal, 10.0)
          .background(RoundedRectangle(cornerRadius: 15).fill(Color("TextColor")))
          .foregroundColor(.black)
        
        if case .success = verification {
            Text("Enter the 6 digit verification code we just sent to your number.")
              .foregroundColor(Color("TextColor"))
              .padding(.top, 50.0)
              .font(.custom("Play-Regular", size: 20))
            TextField("Verification", text: $verificationCode, prompt: Text(""))
              .textContentType(.telephoneNumber)
              .keyboardType(.numberPad)
              .textInputAutocapitalization(.never)
              .autocorrectionDisabled()
              .font(.custom("Play-Regular", size: 50))
              .padding(.horizontal, 10.0)
              .background(RoundedRectangle(cornerRadius: 15).fill(Color("TextColor")))
              .foregroundColor(.black)
        }
        
        Button(action: step == 1 ? signInButtonTapped : verifyTapped, label: {
          Text(buttonText)
            .font(.system(size: 24, weight: .bold, design: .default))
            .frame(maxWidth: 200, maxHeight: 60)
            .foregroundColor(Color.white)
            .background(Color("PrimaryColor"))
            .cornerRadius(10)
        })
        .disabled(isLoading)
        .padding(.top, 50.0)
        
        Text(errorText)
          .foregroundColor(Color("SecondaryColor"))
          .padding(.top, 40.0)
        
        Spacer()
        Text("By entering your phone number, you consent to receiving SMS verification messages from Pressboxd.")
          .font(.footnote)
          .padding(.horizontal, 10.0)
          .foregroundColor(Color("TextColor"))
      }.padding(30)
    }
  }
  
  func signInButtonTapped() {
    Task {
      isLoading = true
      defer { isLoading = false }
      
      do {
        try await supabase.auth.signInWithOTP(
          phone: "+1\(phone)"
        )
        
        verification = .success(())
        step += 1
        buttonText = "Verify Phone"
        errorText = ""
      } catch {
        verification = .failure(error)
        errorText = "Invalid phone number. Please try again."
      }
    }
  }
  
  func verifyTapped() {
    Task {
      isLoading = true
      defer { isLoading = false }
      
      do {
        try await supabase.auth.verifyOTP(
          phone: "+1\(phone)",
          token: verificationCode,
          type: .sms
        )
      } catch {
        errorText = error.localizedDescription
      }
    }
  }
}

#Preview {
  AuthView()
}
