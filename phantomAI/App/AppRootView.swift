//
//  AppRootView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Root view that determines initial app destination based on authentication and onboarding status
struct AppRootView: View {
    @Environment(\.container) private var container
    @State private var startDestination: AppStartDestination = .welcome
    @State private var showingAuth = false
    
    var body: some View {
        Group {
            switch startDestination {
            case .welcome:
                WelcomeView(
                    onGetStarted: {
                        showingAuth = true
                    },
                    onSignIn: {
                        showingAuth = true
                    }
                )
                .fullScreenCover(isPresented: $showingAuth) {
                    AuthView(container: container) {
                        // User signed in - determine next step
                        handleSignedIn()
                    }
                }
                
            case .auth:
                AuthView(container: container) {
                    // User signed in - determine next step
                    handleSignedIn()
                }
                
            case .onboarding:
                OnboardingView(container: container) {
                    // Onboarding completed - switch to main app
                    withAnimation {
                        startDestination = .main
                    }
                }
                
            case .main:
                RootTabView()
            }
        }
        .onAppear {
            // Determine initial destination based on auth and onboarding status
            determineStartDestination()
        }
    }
    
    /// Determine the initial destination when the app launches
    private func determineStartDestination() {
        // TEMP: always start at Welcome while we build onboarding
        startDestination = .welcome
        
        // TODO: restore real logic later:
        /*
        let hasUserId = container.authService.currentUserId != nil
        let isOnboardingCompleted = container.localStorageService.isOnboardingCompleted()
        
        if !hasUserId {
            startDestination = .welcome
        } else if !isOnboardingCompleted {
            startDestination = .onboarding
        } else {
            startDestination = .main
        }
        */
    }
    
    /// Handle successful authentication
    private func handleSignedIn() {
        showingAuth = false
        let isOnboardingCompleted = container.localStorageService.isOnboardingCompleted()
        
        withAnimation {
            if isOnboardingCompleted {
                startDestination = .main
            } else {
                startDestination = .onboarding
            }
        }
    }
}

#Preview {
    AppRootView()
        .environment(\.container, AppContainer.preview)
}

