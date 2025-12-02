//
//  Program.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Represents a fitness program created for a user
struct Program: Codable, Identifiable {
    let id: String
    let userId: String
    let name: String
    let description: String
    let startDate: Date
    let endDate: Date?
    let workouts: [WorkoutPlan]
    let createdAt: Date
    
    struct WorkoutPlan: Codable, Identifiable {
        let id: String
        let name: String
        let exercises: [Exercise]
        let scheduledDate: Date?
    }
    
    struct Exercise: Codable, Identifiable {
        let id: String
        let name: String
        let sets: Int
        let reps: Int?
        let weight: Double?
        let duration: TimeInterval?
    }
}

