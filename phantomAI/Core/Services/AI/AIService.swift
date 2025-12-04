//
//  AIService.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Protocol for AI service
/// Handles program generation and chat interactions
protocol AIService {
    /// Build a personalized program based on program request
    /// - Parameter request: ProgramRequest containing all user onboarding data
    /// - Returns: A personalized Program with workouts and exercises
    /// - Throws: Error if program generation fails
    func buildProgram(for request: ProgramRequest) async throws -> Program
    
    /// Send messages to AI and get responses
    func chat(messages: [AIMessage]) async throws -> [AIMessage]
}


