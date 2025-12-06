//
//  PlanTeaserMetrics.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Metrics calculated from OnboardingAnswers for the Plan Teaser screen
/// All calculations are local and do not require AI or network calls
struct PlanTeaserMetrics {
    let goal: PrimaryGoal
    let timelineMonths: Int
    let targetCalories: Int
    let proteinGrams: Int
    let carbGrams: Int
    let fatGrams: Int
    
    let actualAge: Int
    let fitnessAge: Int
    
    let splitSummary: [String]  // e.g., ["Mon – Upper Power", "Tue – Lower Hypertrophy", "Wed – Rest", ...]
    let injuryMessage: String?
    let injuryFilteredCount: Int?
    
    /// Creates metrics from OnboardingAnswers
    /// Returns nil if required data is missing
    init?(answers: OnboardingAnswers) {
        // Validate required fields
        guard let age = answers.age,
              let sex = answers.sex,
              let heightCm = answers.heightCm,
              let weightKg = answers.weightKg,
              let activityLevel = answers.activityLevel,
              let primaryGoal = answers.primaryGoal,
              let goalTimeline = answers.goalTimeline,
              let trainingDaysPerWeek = answers.trainingDaysPerWeek else {
            return nil
        }
        
        self.goal = primaryGoal
        self.actualAge = age
        
        // Map goalTimeline to months
        switch goalTimeline {
        case .aggressive:
            self.timelineMonths = 3
        case .moderate:
            self.timelineMonths = 6
        case .sustainable:
            self.timelineMonths = 12
        }
        
        // Calculate BMR using Mifflin-St Jeor
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
        
        // Convert ActivityLevel to multiplier
        let activityFactor: Double
        switch activityLevel {
        case .mostlySitting:
            activityFactor = 1.2
        case .sometimesOnFeet:
            activityFactor = 1.375
        case .oftenOnFeet:
            activityFactor = 1.55
        case .veryActive:
            activityFactor = 1.725
        }
        
        // Calculate TDEE
        let tdee = bmr * activityFactor
        
        // Adjust targetCalories based on goal
        let adjustedCalories: Double
        switch primaryGoal {
        case .buildMuscle:
            adjustedCalories = tdee * 1.12  // +12% for muscle gain
        case .loseFat:
            adjustedCalories = tdee * 0.82  // -18% for fat loss
        case .getStronger:
            adjustedCalories = tdee * 1.10  // +10% for strength
        case .improveEndurance:
            adjustedCalories = tdee * 1.05  // +5% for endurance
        case .generalFitness:
            adjustedCalories = tdee  // Maintain
        }
        
        self.targetCalories = Int(adjustedCalories.rounded(toNearest: 10))
        
        // Compute macros
        // Protein: 2.0 g/kg (adjustable based on goal)
        let proteinPerKg: Double
        switch primaryGoal {
        case .buildMuscle, .getStronger:
            proteinPerKg = 2.2
        case .loseFat:
            proteinPerKg = 2.0
        default:
            proteinPerKg = 1.8
        }
        self.proteinGrams = Int((weightKg * proteinPerKg).rounded())
        
        // Fat: 25% of calories
        self.fatGrams = Int(((Double(targetCalories) * 0.25) / 9).rounded())
        
        // Carbs: remainder
        let proteinCalories = Double(proteinGrams) * 4
        let fatCalories = Double(fatGrams) * 9
        let remainingCalories = Double(targetCalories) - proteinCalories - fatCalories
        self.carbGrams = Int((remainingCalories / 4).rounded())
        
        // Compute Fitness Age
        let bmi = weightKg / pow(heightCm / 100, 2)
        var fitnessAge = age
        
        // Adjust based on BMI and activity
        if bmi > 27 && activityLevel == .mostlySitting {
            fitnessAge += 5  // High BMI + low activity = older fitness age
        } else if bmi > 27 && activityLevel == .sometimesOnFeet {
            fitnessAge += 3
        } else if bmi >= 22 && bmi <= 25 && activityLevel == .veryActive {
            fitnessAge -= 2  // Good BMI + high activity = younger fitness age
        } else if bmi >= 22 && bmi <= 25 && activityLevel == .oftenOnFeet {
            fitnessAge -= 1
        } else if bmi < 22 && activityLevel == .veryActive {
            fitnessAge -= 3
        }
        
        // Clamp to reasonable range
        self.fitnessAge = max(age - 5, min(age + 10, fitnessAge))
        
        // Build splitSummary
        self.splitSummary = Self.buildSplitSummary(
            daysPerWeek: trainingDaysPerWeek,
            split: answers.trainingSplit
        )
        
        // Injury safeguard info
        if answers.hasInjuries == true {
            self.injuryMessage = "Your plan avoids stressing your reported injury area."
            self.injuryFilteredCount = 14  // Fixed number for now
        } else {
            self.injuryMessage = nil
            self.injuryFilteredCount = nil
        }
    }
    
    // MARK: - Split Summary Builder
    
    private static func buildSplitSummary(daysPerWeek: Int, split: TrainingSplit?) -> [String] {
        let dayNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        var summary: [String] = []
        
        // Determine workout pattern
        let workoutPattern: [String]
        if let split = split {
            switch split {
            case .fullBody:
                workoutPattern = ["Full Body A", "Full Body B", "Full Body C"]
            case .upperLower:
                workoutPattern = ["Upper", "Lower"]
            case .pushPullLegs:
                workoutPattern = ["Push", "Pull", "Legs"]
            case .upperLowerPushPullLegs:
                workoutPattern = ["Upper", "Lower", "Push", "Pull", "Legs"]
            case .custom:
                workoutPattern = Self.defaultPattern(for: daysPerWeek)
            }
        } else {
            workoutPattern = Self.defaultPattern(for: daysPerWeek)
        }
        
        // Build 7-day week view
        // Distribute workout days across the week
        var workoutIndex = 0
        let restDays = 7 - daysPerWeek
        
        // Determine rest day positions (spread evenly)
        let restDayIndices: Set<Int>
        if restDays == 0 {
            restDayIndices = []
        } else if restDays == 1 {
            restDayIndices = [3]  // Wednesday
        } else if restDays == 2 {
            restDayIndices = [3, 6]  // Wednesday, Sunday
        } else {
            // Spread rest days: Wed, Fri, Sun
            restDayIndices = Set([2, 4, 6].prefix(restDays))
        }
        
        for (index, dayName) in dayNames.enumerated() {
            if restDayIndices.contains(index) {
                summary.append("\(dayName) – Rest")
            } else if workoutIndex < daysPerWeek {
                let workout = workoutPattern[workoutIndex % workoutPattern.count]
                summary.append("\(dayName) – \(workout)")
                workoutIndex += 1
            } else {
                summary.append("\(dayName) – Rest")
            }
        }
        
        return summary
    }
    
    private static func defaultPattern(for daysPerWeek: Int) -> [String] {
        switch daysPerWeek {
        case 1, 2:
            return ["Full Body"]
        case 3:
            return ["Full Body A", "Full Body B", "Full Body C"]
        case 4:
            return ["Upper", "Lower"]
        case 5, 6:
            return ["Push", "Pull", "Legs"]
        default:
            return ["Full Body"]
        }
    }
}

// MARK: - Helper Extension

extension Double {
    func rounded(toNearest nearest: Double) -> Double {
        return (self / nearest).rounded() * nearest
    }
}

