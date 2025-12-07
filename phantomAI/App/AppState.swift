//
//  AppState.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation
import Combine

/// Central app state that tracks user progress through onboarding, auth, and subscription
final class AppState: ObservableObject {
    // MARK: - Published Properties
    
    @Published var hasCompletedOnboarding: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var hasActiveSubscription: Bool = false
    @Published var shouldShowPostPurchaseChat: Bool = false
    @Published var selectedTab: Int = 0
    
    // MARK: - Computed Properties
    
    /// Determines which high-level view to show based on current state
    var currentPhase: AppPhase {
        if !hasCompletedOnboarding {
            return .onboarding
        } else if !isAuthenticated {
            return .authentication
        } else if !hasActiveSubscription {
            return .paywall
        } else {
            return .main
        }
    }
    
    // MARK: - Initialization
    
    init() {
        // Load persisted state if needed
        // For now, start fresh
    }
    
    // MARK: - Post-Purchase Chat
    
    func completePostPurchaseChat() {
        shouldShowPostPurchaseChat = false
    }
}

// MARK: - App Phase Enum

enum AppPhase {
    case onboarding      // User is going through onboarding questions
    case authentication  // User needs to sign in (SaveProgressView)
    case paywall         // User needs to subscribe (PaywallView)
    case main            // User is in the main app (RootTabView)
}

