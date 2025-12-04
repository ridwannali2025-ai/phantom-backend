//
//  MockAIService.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Mock implementation of AIService for development and previews
/// TODO: Replace with real AI service (OpenAI API, Anthropic, etc.)
final class MockAIService: AIService {
    func buildProgram(for request: ProgramRequest) async throws -> Program {
        // Simulate AI processing delay
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Generate program name based on goal
        let programName: String
        switch request.goal {
        case .buildMuscle:
            programName = "Hypertrophy Focus – \(request.daysPerWeek)x / week"
        case .loseFat:
            programName = "Fat Loss – \(request.daysPerWeek)x / week"
        case .getStronger:
            programName = "Strength Block – \(request.daysPerWeek)x / week"
        case .improveEndurance:
            programName = "Endurance Builder – \(request.daysPerWeek)x / week"
        case .generalFitness:
            programName = "Total Fitness – \(request.daysPerWeek)x / week"
        }
        
        // Calculate duration in weeks (4-8 weeks based on timeline)
        let weeks: Int
        if request.timelineMonths <= 3 {
            weeks = 6
        } else if request.timelineMonths <= 6 {
            weeks = 8
        } else {
            weeks = 12
        }
        
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: startDate)
        
        // Generate description
        let description = "AI-generated program for \(request.goal.title) goal. \(request.daysPerWeek) days per week, \(request.experience.rawValue) level. Designed for \(weeks) weeks."
        
        // Generate workouts based on days per week
        let workouts = generateWorkouts(
            daysPerWeek: request.daysPerWeek,
            goal: request.goal,
            experience: request.experience,
            weeks: weeks
        )
        
        return Program(
            id: "ai_program_\(UUID().uuidString)",
            userId: "mock_user_id", // TODO: Get from auth context
            name: programName,
            description: description,
            startDate: startDate,
            endDate: endDate,
            workouts: workouts,
            createdAt: Date()
        )
    }
    
    // MARK: - Workout Generation Helpers
    
    private func generateWorkouts(
        daysPerWeek: Int,
        goal: PrimaryGoal,
        experience: TrainingExperience,
        weeks: Int
    ) -> [Program.WorkoutPlan] {
        var workouts: [Program.WorkoutPlan] = []
        
        // Determine split type based on days per week
        let splitType: SplitType
        switch daysPerWeek {
        case 1, 2:
            splitType = .fullBody
        case 3:
            splitType = .fullBodyABC
        case 4:
            splitType = .upperLower
        case 5, 6:
            splitType = .pushPullLegs
        default:
            splitType = .fullBody
        }
        
        // Generate workout names based on split
        let workoutNames = splitType.workoutNames(for: daysPerWeek)
        
        // Generate exercises for each workout type
        for (index, workoutName) in workoutNames.enumerated() {
            let exercises = generateExercises(
                for: workoutName,
                goal: goal,
                experience: experience
            )
            
            // Schedule workouts across the first week
            let daysOffset = index % daysPerWeek
            let scheduledDate = Calendar.current.date(
                byAdding: .day,
                value: daysOffset,
                to: Date()
            )
            
            workouts.append(
                Program.WorkoutPlan(
                    id: "workout_\(index + 1)",
                    name: workoutName,
                    exercises: exercises,
                    scheduledDate: scheduledDate
                )
            )
        }
        
        return workouts
    }
    
    private func generateExercises(
        for workoutName: String,
        goal: PrimaryGoal,
        experience: TrainingExperience
    ) -> [Program.Exercise] {
        // Base sets based on experience
        let baseSets: Int
        switch experience {
        case .beginner:
            baseSets = 3
        case .intermediate:
            baseSets = 4
        case .advanced:
            baseSets = 5
        }
        
        // Exercise selection based on workout name and goal
        let exerciseNames: [String]
        let reps: Int?
        
        if workoutName.contains("Upper") || workoutName.contains("Push") {
            exerciseNames = goal == .getStronger ? [
                "Bench Press",
                "Overhead Press",
                "Barbell Row",
                "Lat Pulldown",
                "Tricep Extension"
            ] : [
                "Bench Press",
                "Dumbbell Flyes",
                "Lat Pulldown",
                "Cable Rows",
                "Shoulder Press",
                "Lateral Raises"
            ]
            reps = goal == .getStronger ? 5 : (goal == .buildMuscle ? 8 : 12)
        } else if workoutName.contains("Lower") || workoutName.contains("Legs") {
            exerciseNames = [
                "Squats",
                "Romanian Deadlift",
                "Leg Press",
                "Leg Curls",
                "Calf Raises"
            ]
            reps = goal == .getStronger ? 5 : (goal == .buildMuscle ? 8 : 12)
        } else if workoutName.contains("Pull") {
            exerciseNames = [
                "Deadlift",
                "Barbell Row",
                "Lat Pulldown",
                "Cable Rows",
                "Bicep Curls"
            ]
            reps = goal == .getStronger ? 5 : (goal == .buildMuscle ? 8 : 12)
        } else {
            // Full Body
            exerciseNames = [
                "Squats",
                "Bench Press",
                "Barbell Row",
                "Overhead Press",
                "Romanian Deadlift"
            ]
            reps = goal == .getStronger ? 5 : (goal == .buildMuscle ? 8 : 12)
        }
        
        return exerciseNames.enumerated().map { index, name in
            Program.Exercise(
                id: "ex_\(index + 1)",
                name: name,
                sets: baseSets,
                reps: reps,
                weight: nil, // Weight will be determined during workout
                duration: nil
            )
        }
    }
    
    // MARK: - Split Type Helper
    
    private enum SplitType {
        case fullBody
        case fullBodyABC
        case upperLower
        case pushPullLegs
        
        func workoutNames(for daysPerWeek: Int) -> [String] {
            switch self {
            case .fullBody:
                return (1...daysPerWeek).map { "Day \($0) – Full Body" }
            case .fullBodyABC:
                return ["Day 1 – Full Body A", "Day 2 – Full Body B", "Day 3 – Full Body C"]
            case .upperLower:
                return ["Day 1 – Upper", "Day 2 – Lower", "Day 3 – Upper", "Day 4 – Lower"]
            case .pushPullLegs:
                let base = ["Day 1 – Push", "Day 2 – Pull", "Day 3 – Legs"]
                if daysPerWeek == 5 {
                    return base + ["Day 4 – Push", "Day 5 – Pull"]
                } else if daysPerWeek == 6 {
                    return base + ["Day 4 – Push", "Day 5 – Pull", "Day 6 – Legs"]
                }
                return base
            }
        }
    }
    
    func chat(messages: [AIMessage]) async throws -> [AIMessage] {
        // TODO: Implement real AI chat (OpenAI API, Anthropic, etc.)
        // Simulate AI response delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Generate mock response
        let lastMessage = messages.last?.content ?? ""
        let response = AIMessage(
            id: UUID().uuidString,
            role: .assistant,
            content: "I understand you're asking about: \(lastMessage). This is a mock response. TODO: Connect to real AI service.",
            timestamp: Date()
        )
        
        return messages + [response]
    }
}


