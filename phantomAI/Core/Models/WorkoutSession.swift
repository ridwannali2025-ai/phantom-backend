//
//  WorkoutSession.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Represents a completed workout session
struct WorkoutSession: Codable, Identifiable {
    let id: String
    let userId: String
    let programId: String?
    let name: String
    let startTime: Date
    let endTime: Date?
    let sets: [WorkoutSet]
    let totalVolume: Double
    let notes: String?
}


