//
//  MockProgramService.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Mock implementation of ProgramService for development and previews
/// TODO: Replace with real program service (API, database, etc.)
final class MockProgramService: ProgramService {
    func fetchCurrentProgram(for userId: String) async throws -> Program? {
        // TODO: Implement real program fetching
        // Simulate network delay
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        
        // Return mock program
        return Program(
            id: "program_1",
            userId: userId,
            name: "12-Week Strength Program",
            description: "A comprehensive strength training program",
            startDate: Date().addingTimeInterval(-7 * 24 * 60 * 60), // 7 days ago
            endDate: Date().addingTimeInterval(77 * 24 * 60 * 60), // 77 days from now
            workouts: [
                Program.WorkoutPlan(
                    id: "workout_1",
                    name: "Upper Body Strength",
                    exercises: [
                        Program.Exercise(
                            id: "ex_1",
                            name: "Bench Press",
                            sets: 4,
                            reps: 8,
                            weight: 80.0,
                            duration: nil
                        )
                    ],
                    scheduledDate: Date()
                )
            ],
            createdAt: Date()
        )
    }
    
    func fetchTodayPlan(for userId: String) async throws -> TodayPlan {
        // TODO: Implement real today plan fetching
        // Simulate network delay
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        
        // Return mock today plan
        return TodayPlan(
            id: "today_plan_1",
            userId: userId,
            date: Date(),
            workouts: [
                TodayPlan.WorkoutPlan(
                    id: "workout_1",
                    name: "Upper Body Strength",
                    exercises: [
                        TodayPlan.Exercise(
                            id: "ex_1",
                            name: "Bench Press",
                            sets: 4,
                            reps: 8,
                            weight: 80.0
                        )
                    ],
                    estimatedDuration: 3600 // 1 hour
                )
            ],
            meals: [
                TodayPlan.MealPlan(
                    id: "meal_1",
                    name: "Protein Oatmeal",
                    mealType: .breakfast,
                    calories: 450,
                    macros: TodayPlan.Macros(protein: 30, carbs: 50, fats: 12),
                    ingredients: ["Oats", "Protein Powder", "Banana"]
                )
            ],
            notes: "Focus on form today"
        )
    }
}

