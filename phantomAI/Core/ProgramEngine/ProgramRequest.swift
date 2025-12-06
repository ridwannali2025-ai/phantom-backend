//
//  ProgramRequest.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Represents the data structure sent to AI for generating a personalized workout program
/// Maps from OnboardingAnswers to a format suitable for AI program generation
struct ProgramRequest: Codable {
    // MARK: - Required Core Fields
    
    /// Primary fitness goal
    let goal: PrimaryGoal
    
    /// Timeline preference mapped to months (aggressive ≈ 3, moderate ≈ 6, sustainable ≈ 9-12)
    let timelineMonths: Int
    
    /// User's height in centimeters
    let heightCm: Double
    
    /// User's weight in kilograms
    let weightKg: Double
    
    /// User's age
    let age: Int
    
    /// User's sex
    let sex: SexType
    
    /// Activity level outside of workouts
    let activityLevel: ActivityLevel
    
    /// Number of training days per week
    let daysPerWeek: Int
    
    /// Training experience level
    let experience: TrainingExperience
    
    /// Available equipment options
    let equipment: [EquipmentOption]
    
    // MARK: - Optional Fields
    
    /// Whether user has injuries
    let hasInjuries: Bool?
    
    /// Details about injuries (if any)
    let injuryDetails: String?
    
    /// Dietary restrictions
    let dietaryRestrictions: [DietaryRestriction]?
    
    /// Foods to avoid
    let avoidFoods: String?
    
    /// Coach style preference
    let coachStyle: CoachStyle?
    
    /// Preferred workout time
    let workoutTime: WorkoutTime?
    
    /// Sleep hours per night
    let sleepHours: Double?
    
    /// Session length in minutes (if specified in onboarding)
    let sessionLengthMinutes: Int?
    
    /// Training split preference (if specified in onboarding)
    let trainingSplit: TrainingSplit?
}

// MARK: - Mapping from OnboardingAnswers

extension ProgramRequest {
    /// Creates a ProgramRequest from OnboardingAnswers
    /// Returns nil if required fields are missing
    init?(from answers: OnboardingAnswers) {
        // Validate required fields
        guard let goal = answers.primaryGoal,
              let goalTimeline = answers.goalTimeline,
              let heightCm = answers.heightCm,
              let weightKg = answers.weightKg,
              let age = answers.age,
              let sex = answers.sex,
              let activityLevel = answers.activityLevel,
              let daysPerWeek = answers.trainingDaysPerWeek,
              let experience = answers.trainingExperience else {
            return nil
        }
        
        // Map goalTimeline to months
        let timelineMonths: Int
        switch goalTimeline {
        case .aggressive:
            timelineMonths = 3
        case .moderate:
            timelineMonths = 6
        case .sustainable:
            timelineMonths = 12
        }
        
        // Initialize with required fields
        self.goal = goal
        self.timelineMonths = timelineMonths
        self.heightCm = heightCm
        self.weightKg = weightKg
        self.age = age
        self.sex = sex
        self.activityLevel = activityLevel
        self.daysPerWeek = daysPerWeek
        self.experience = experience
        self.equipment = answers.equipment
        
        // Optional fields
        self.hasInjuries = answers.hasInjuries
        self.injuryDetails = answers.injuryDetails
        self.dietaryRestrictions = answers.dietaryRestrictions?.isEmpty == false ? answers.dietaryRestrictions : nil
        self.avoidFoods = answers.avoidFoods?.isEmpty == false ? answers.avoidFoods : nil
        self.coachStyle = answers.coachStyle
        self.workoutTime = answers.workoutTime
        self.sleepHours = answers.sleepHours
        self.sessionLengthMinutes = answers.sessionLengthMinutes
        self.trainingSplit = answers.trainingSplit
    }
}

