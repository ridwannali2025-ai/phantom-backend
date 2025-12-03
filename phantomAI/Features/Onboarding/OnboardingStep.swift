//
//  OnboardingStep.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Represents each step in the onboarding flow
enum OnboardingStep: Int, CaseIterable, Codable {
    // Phase 1 – Goals & motivation
    case primaryGoal = 0
    case goalTimeline = 1
    case commitmentScore = 2
    case pastBarriers = 3
    
    // Phase 2 – Biometric & lifestyle
    case sex = 4
    case age = 5
    case heightWeight = 6
    case activityLevel = 7
    case sleepHours = 8
    case workoutTime = 9
    
    // Phase 3 – Training profile
    case equipment = 10
    case trainingDaysPerWeek = 11      // already implemented
    case trainingExperience = 12        // already implemented
    case injuries = 13
    
    // Phase 4 – Nutrition profile
    case dietaryRestrictions = 14
    case avoidFoods = 15
    case cookingComfort = 16
    
    // Phase 5 – Coach persona
    case coachStyle = 17
    
    // Final step
    case processing = 18
    
    /// Total number of steps in the onboarding flow
    static var totalSteps: Int {
        return OnboardingStep.allCases.count
    }
    
    /// Get the step index (0-based) for use in UI components like progress indicators
    var stepIndex: Int {
        return OnboardingStep.allCases.firstIndex(of: self) ?? 0
    }
    
    /// Get the next step, or nil if at the last step
    func next() -> OnboardingStep? {
        guard let currentIndex = OnboardingStep.allCases.firstIndex(of: self) else { return nil }
        let nextIndex = currentIndex + 1
        guard nextIndex < OnboardingStep.allCases.count else { return nil }
        return OnboardingStep.allCases[nextIndex]
    }
    
    /// Get the previous step, or nil if at the first step
    func previous() -> OnboardingStep? {
        guard let currentIndex = OnboardingStep.allCases.firstIndex(of: self) else { return nil }
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else { return nil }
        return OnboardingStep.allCases[previousIndex]
    }
}

