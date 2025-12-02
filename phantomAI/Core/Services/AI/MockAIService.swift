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
    func buildProgram(for profile: UserProfile) async throws -> Program {
        // TODO: Implement real AI program generation
        // Simulate AI processing delay
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Return mock program based on profile
        return Program(
            id: "ai_program_\(UUID().uuidString)",
            userId: profile.userId,
            name: "Personalized \(profile.fitnessLevel.rawValue.capitalized) Program",
            description: "AI-generated program based on your goals: \(profile.goals.map { $0.rawValue }.joined(separator: ", "))",
            startDate: Date(),
            endDate: Date().addingTimeInterval(84 * 24 * 60 * 60), // 12 weeks
            workouts: [
                Program.WorkoutPlan(
                    id: "workout_1",
                    name: "Full Body Workout",
                    exercises: [
                        Program.Exercise(
                            id: "ex_1",
                            name: "Squats",
                            sets: 3,
                            reps: 12,
                            weight: nil,
                            duration: nil
                        )
                    ],
                    scheduledDate: Date()
                )
            ],
            createdAt: Date()
        )
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

