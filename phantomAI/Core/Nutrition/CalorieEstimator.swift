//
//  CalorieEstimator.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Purely deterministic calorie estimation from onboarding answers
/// No network calls, no AI - just local calculations
struct CalorieEstimator {
    static func dailyCalories(from answers: OnboardingAnswers) -> Int {
        // Pull values safely with fallbacks
        let sex = answers.sex ?? .male
        let age = answers.age ?? 25
        let heightCm = answers.heightCm ?? 175.0
        let weightKg = answers.weightKg ?? 75.0
        let activityLevel = answers.activityLevel ?? .sometimesOnFeet
        let goal = answers.primaryGoal ?? .loseFat
        
        // 1) Convert cm/kg to numbers (already done above)
        
        // 2) Compute BMR using Mifflin-St Jeor
        let bmr: Double
        switch sex {
        case .male:
            bmr = 10 * weightKg + 6.25 * heightCm - 5 * Double(age) + 5
        case .female:
            bmr = 10 * weightKg + 6.25 * heightCm - 5 * Double(age) - 161
        case .other:
            // Use average of male/female formula
            bmr = 10 * weightKg + 6.25 * heightCm - 5 * Double(age) - 78
        }
        
        // 3) Apply activity factor based on activityLevel
        let activityFactor: Double
        switch activityLevel {
        case .mostlySitting:
            activityFactor = 1.2  // sedentary
        case .sometimesOnFeet:
            activityFactor = 1.375  // light
        case .oftenOnFeet:
            activityFactor = 1.55  // moderate
        case .veryActive:
            activityFactor = 1.725  // very active
        }
        
        let maintenanceCalories = bmr * activityFactor
        
        // 4) Adjust for goal
        let adjustedCalories: Double
        switch goal {
        case .loseFat:
            adjustedCalories = maintenanceCalories - 400
        case .buildMuscle, .getStronger:
            adjustedCalories = maintenanceCalories + 200
        case .improveEndurance, .generalFitness:
            adjustedCalories = maintenanceCalories  // maintenance
        }
        
        // 5) Round to nearest 10 and clamp to safe range
        let rounded = (adjustedCalories / 10).rounded() * 10
        let clamped = max(1200, min(4000, rounded))
        
        // 6) Return as Int
        return Int(clamped)
    }
}

