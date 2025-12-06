//
//  ProgramBuilderService.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Protocol for program building service
protocol ProgramBuilderService {
    func generateProgram(from answers: OnboardingAnswers) async throws -> GeneratedProgram
}

/// Mock implementation that returns sample data
struct MockProgramBuilderService: ProgramBuilderService {
    func generateProgram(from answers: OnboardingAnswers) async throws -> GeneratedProgram {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 4_000_000_000) // 4 seconds
        
        // Generate mock program based on answers
        let programId = UUID().uuidString
        let workoutCount = answers.trainingDaysPerWeek ?? 3
        
        let workouts = (0..<workoutCount).map { index -> GeneratedProgram.WorkoutPlan in
            let workoutNames = ["Upper Body", "Lower Body", "Full Body", "Push", "Pull", "Legs"]
            let workoutName = workoutNames[index % workoutNames.count]
            
            return GeneratedProgram.WorkoutPlan(
                id: UUID().uuidString,
                name: workoutName,
                exercises: generateMockExercises(),
                scheduledDate: nil
            )
        }
        
        // Calculate nutrition targets (simplified)
        let targetCalories = calculateTargetCalories(from: answers)
        let proteinGrams = Int(Double(targetCalories) * 0.25 / 4.0) // 25% of calories from protein
        let carbGrams = Int(Double(targetCalories) * 0.45 / 4.0)   // 45% from carbs
        let fatGrams = Int(Double(targetCalories) * 0.30 / 9.0)     // 30% from fat
        
        return GeneratedProgram(
            id: programId,
            name: "\(answers.primaryGoal?.title ?? "Personalized") Program",
            description: "A customized program designed for your goals and lifestyle.",
            workouts: workouts,
            nutritionPlan: GeneratedProgram.NutritionPlan(
                targetCalories: targetCalories,
                proteinGrams: proteinGrams,
                carbGrams: carbGrams,
                fatGrams: fatGrams,
                mealSuggestions: generateMockMeals()
            ),
            createdAt: Date()
        )
    }
    
    private func generateMockExercises() -> [GeneratedProgram.WorkoutPlan.Exercise] {
        [
            GeneratedProgram.WorkoutPlan.Exercise(
                id: UUID().uuidString,
                name: "Bench Press",
                sets: 3,
                reps: 8,
                weight: nil,
                duration: nil
            ),
            GeneratedProgram.WorkoutPlan.Exercise(
                id: UUID().uuidString,
                name: "Squats",
                sets: 3,
                reps: 10,
                weight: nil,
                duration: nil
            ),
            GeneratedProgram.WorkoutPlan.Exercise(
                id: UUID().uuidString,
                name: "Pull-ups",
                sets: 3,
                reps: 8,
                weight: nil,
                duration: nil
            )
        ]
    }
    
    private func generateMockMeals() -> [GeneratedProgram.NutritionPlan.MealSuggestion] {
        [
            GeneratedProgram.NutritionPlan.MealSuggestion(
                id: UUID().uuidString,
                name: "Grilled Chicken & Rice",
                calories: 500,
                proteinGrams: 40,
                carbGrams: 50,
                fatGrams: 10
            ),
            GeneratedProgram.NutritionPlan.MealSuggestion(
                id: UUID().uuidString,
                name: "Salmon & Vegetables",
                calories: 450,
                proteinGrams: 35,
                carbGrams: 30,
                fatGrams: 20
            )
        ]
    }
    
    private func calculateTargetCalories(from answers: OnboardingAnswers) -> Int {
        // Simplified BMR calculation
        guard let weightKg = answers.weightKg,
              let heightCm = answers.heightCm,
              let age = answers.age,
              let sex = answers.sex else {
            return 2000 // Default
        }
        
        // Mifflin-St Jeor Equation (simplified)
        let baseBMR: Double
        switch sex {
        case .male:
            baseBMR = 10 * weightKg + 6.25 * heightCm - 5 * Double(age) + 5
        case .female:
            baseBMR = 10 * weightKg + 6.25 * heightCm - 5 * Double(age) - 161
        case .other:
            baseBMR = 10 * weightKg + 6.25 * heightCm - 5 * Double(age) - 78
        }
        
        // Activity multiplier
        let activityMultiplier: Double
        switch answers.activityLevel {
        case .mostlySitting:
            activityMultiplier = 1.2
        case .sometimesOnFeet:
            activityMultiplier = 1.375
        case .oftenOnFeet:
            activityMultiplier = 1.55
        case .veryActive:
            activityMultiplier = 1.725
        case .none:
            activityMultiplier = 1.2
        }
        
        var targetCalories = Int(baseBMR * activityMultiplier)
        
        // Adjust based on goal
        if let goal = answers.primaryGoal {
            switch goal {
            case .loseFat:
                targetCalories -= 500 // Deficit
            case .buildMuscle:
                targetCalories += 300 // Surplus
            default:
                break
            }
        }
        
        return max(1200, min(4000, targetCalories)) // Clamp to reasonable range
    }
}

