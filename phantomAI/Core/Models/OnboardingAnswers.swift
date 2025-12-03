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
    var trainingDaysPerWeek: Int?
    var trainingExperience: TrainingExperience?
    
    // TODO: add equipment, etc. later
}

/// Training experience levels
enum TrainingExperience: String, CaseIterable, Identifiable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    
    var id: String { rawValue }
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

