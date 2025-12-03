//
//  OnboardingAnswers.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Stores user answers from the onboarding flow
struct OnboardingAnswers: Codable {
    var goal: FitnessGoal?
    
    // TODO: add experience, schedule, equipment, etc. later
}

/// Fitness goal options for onboarding
enum FitnessGoal: String, CaseIterable, Codable, Identifiable {
    case buildMuscle = "Build muscle"
    case loseFat = "Lose fat"
    case getStronger = "Get stronger"
    case recomposition = "Recomp"
    case generalFitness = "General fitness"
    
    var id: String { rawValue }
}

