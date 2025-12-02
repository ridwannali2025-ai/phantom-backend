//
//  WorkoutSet.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Represents a single set logged during a workout
struct WorkoutSet: Codable, Identifiable {
    let id: String
    let exerciseId: String
    let exerciseName: String
    let setNumber: Int
    let reps: Int?
    let weight: Double?
    let duration: TimeInterval?
    let restTime: TimeInterval?
    let completedAt: Date
    let userId: String
}

