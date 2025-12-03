//
//  AppStartDestination.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Represents the initial destination when the app launches
enum AppStartDestination {
    /// Show welcome screen for users who haven't signed in
    case welcome
    /// Show onboarding flow for new users who have signed in but not completed onboarding
    case onboarding
    /// Show main app interface for returning users with onboarding completed
    case main
}

