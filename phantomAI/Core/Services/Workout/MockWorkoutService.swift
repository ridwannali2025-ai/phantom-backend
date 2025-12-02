//
//  MockWorkoutService.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Mock implementation of WorkoutService for development and previews
/// TODO: Replace with real workout service (API, database, etc.)
final class MockWorkoutService: WorkoutService {
    private var loggedSets: [WorkoutSet] = []
    private var sessions: [WorkoutSession] = []
    
    func logSet(_ set: WorkoutSet) async throws {
        // TODO: Implement real set logging (API call, database save, etc.)
        // Simulate network delay
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        
        loggedSets.append(set)
    }
    
    func fetchRecentSessions(for userId: String) async throws -> [WorkoutSession] {
        // TODO: Implement real session fetching
        // Simulate network delay
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        
        // Return mock sessions if empty
        if sessions.isEmpty {
            sessions = [
                WorkoutSession(
                    id: "session_1",
                    userId: userId,
                    programId: "program_1",
                    name: "Upper Body Strength",
                    startTime: Date().addingTimeInterval(-2 * 24 * 60 * 60), // 2 days ago
                    endTime: Date().addingTimeInterval(-2 * 24 * 60 * 60 + 3600), // 1 hour later
                    sets: [],
                    totalVolume: 2400.0,
                    notes: "Great session!"
                )
            ]
        }
        
        return sessions
    }
}

