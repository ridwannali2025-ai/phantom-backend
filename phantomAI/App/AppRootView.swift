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
    @StateObject private var appState = AppState()
    
    var body: some View {
        Group {
            // Use AppState to determine which phase to show
            switch appState.currentPhase {
            case .onboarding, .authentication, .paywall:
                // All onboarding-related phases are handled within OnboardingFlowView
                // The flow will navigate to sign-up (authentication) and paywall automatically
                OnboardingFlowView()
                    .environmentObject(appState)
                
            case .main:
                // User has completed onboarding, authenticated, and subscribed
                RootTabView()
            }
        }
    }
}

#Preview {
    AppRootView()
        .environment(\.container, AppContainer.preview)
}

