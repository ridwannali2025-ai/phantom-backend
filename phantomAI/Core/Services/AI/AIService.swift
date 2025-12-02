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
    /// Build a personalized program based on user profile
    func buildProgram(for profile: UserProfile) async throws -> Program
    
    /// Send messages to AI and get responses
    func chat(messages: [AIMessage]) async throws -> [AIMessage]
}


