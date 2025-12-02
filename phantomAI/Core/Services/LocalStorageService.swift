//
//  LocalStorageService.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Protocol for local storage service
/// Handles persistent local data storage using UserDefaults or similar
protocol LocalStorageService {
    /// Set onboarding completion status
    func setOnboardingCompleted(_ completed: Bool)
    
    /// Check if onboarding has been completed
    func isOnboardingCompleted() -> Bool
}

