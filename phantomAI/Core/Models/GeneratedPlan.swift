//
//  GeneratedPlan.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Simplified plan data for display in the plan summary screen
struct GeneratedPlan: Codable {
    let caloriesPerDay: Int
    let proteinGrams: Int
    let carbsGrams: Int
    let fatsGrams: Int
    let trainingSplitTitle: String
    let trainingSplitSubtitle: String
}

