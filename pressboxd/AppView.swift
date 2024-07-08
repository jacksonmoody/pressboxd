//
//  AppView.swift
//  pressboxd
//
//  Created by Jackson Moody on 6/22/24.
//

import SwiftUI

struct AppView: View {
    @State var loading = true
    @State var isAuthenticated = false
    @State var isOnboarded = false
    
    var body: some View {
        Group {
            if (loading) {
                LoadingView()
            } else if (isAuthenticated && isOnboarded) {
                NavbarView()
            } else if (isAuthenticated) {
                OnboardingView(isOnboarded:$isOnboarded)
            } else {
                AuthView()
            }
        }
        .task {
            for await state in await supabase.auth.authStateChanges {
                if [.initialSession, .signedIn, .signedOut].contains(state.event) {
                    isAuthenticated = state.session != nil
                }
                do {
                    let user = try await supabase.auth.user()
                    let users: [Profile] = try await supabase
                        .from("users")
                        .select()
                        .eq("id", value: user.id)
                        .execute()
                        .value
                    if(!users.isEmpty && users[0].onboarded) {
                        isOnboarded = true
                    }
                    loading = false
                } catch {
                    loading = false
                }
            }
        }
    }
}

#Preview {
    AppView()
}

