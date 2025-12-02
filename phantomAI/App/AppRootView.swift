//
//  AppRootView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Root view that determines initial app destination based on onboarding status
struct AppRootView: View {
    @Environment(\.container) private var container
    @State private var startDestination: AppStartDestination = .onboarding
    
    var body: some View {
        Group {
            switch startDestination {
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
            // Determine initial destination based on onboarding status
            determineStartDestination()
        }
    }
    
    /// Determine the initial destination when the app launches
    private func determineStartDestination() {
        let isOnboardingCompleted = container.localStorageService.isOnboardingCompleted()
        startDestination = isOnboardingCompleted ? .main : .onboarding
    }
}

#Preview {
    AppRootView()
        .environment(\.container, AppContainer.preview)
}

