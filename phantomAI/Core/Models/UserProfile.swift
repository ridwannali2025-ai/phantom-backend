//
//  UserProfile.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Represents a user's profile information used for program generation
struct UserProfile: Codable {
    let userId: String
    let age: Int?
    let height: Double? // in cm
    let weight: Double? // in kg
    let fitnessLevel: FitnessLevel
    let goals: [FitnessGoal]
    let preferences: [String]
    let injuries: [String]
    let availableEquipment: [String]
    let timePerWeek: Int? // hours
    
    enum FitnessLevel: String, Codable {
        case beginner
        case intermediate
        case advanced
    }
    
    enum FitnessGoal: String, Codable {
        case weightLoss
        case muscleGain
        case endurance
        case strength
        case flexibility
        case generalFitness
    }
}

