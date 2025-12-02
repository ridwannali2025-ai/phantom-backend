//
//  UserDefaultsLocalStorageService.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// UserDefaults-based implementation of LocalStorageService
/// Uses UserDefaults.standard for persistent local storage
final class UserDefaultsLocalStorageService: LocalStorageService {
    private let userDefaults: UserDefaults
    private let onboardingKey = "onboarding_completed"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func setOnboardingCompleted(_ completed: Bool) {
        userDefaults.set(completed, forKey: onboardingKey)
    }
    
    func isOnboardingCompleted() -> Bool {
        return userDefaults.bool(forKey: onboardingKey)
    }
}

