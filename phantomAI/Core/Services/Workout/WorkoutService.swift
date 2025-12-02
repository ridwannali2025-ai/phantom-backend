//
//  WorkoutService.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Protocol for workout service
/// Handles logging workout sets and fetching workout sessions
protocol WorkoutService {
    /// Log a completed workout set
    func logSet(_ set: WorkoutSet) async throws
    
    /// Fetch recent workout sessions for a user
    func fetchRecentSessions(for userId: String) async throws -> [WorkoutSession]
}

