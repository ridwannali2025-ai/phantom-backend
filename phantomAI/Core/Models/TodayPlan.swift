//
//  TodayPlan.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Represents the plan for today's activities
struct TodayPlan: Codable, Identifiable {
    let id: String
    let userId: String
    let date: Date
    let workouts: [WorkoutPlan]
    let meals: [MealPlan]
    let notes: String?
    
    struct WorkoutPlan: Codable, Identifiable {
        let id: String
        let name: String
        let exercises: [Exercise]
        let estimatedDuration: TimeInterval
    }
    
    struct Exercise: Codable, Identifiable {
        let id: String
        let name: String
        let sets: Int
        let reps: Int?
        let weight: Double?
    }
    
    struct MealPlan: Codable, Identifiable {
        let id: String
        let name: String
        let mealType: MealType
        let calories: Int
        let macros: Macros
        let ingredients: [String]
    }
    
    enum MealType: String, Codable {
        case breakfast
        case lunch
        case dinner
        case snack
    }
    
    struct Macros: Codable {
        let protein: Double
        let carbs: Double
        let fats: Double
    }
}

