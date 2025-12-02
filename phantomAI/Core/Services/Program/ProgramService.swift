//
//  ProgramService.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Protocol for program service
/// Handles fetching user programs and daily plans
protocol ProgramService {
    /// Fetch the current active program for a user
    func fetchCurrentProgram(for userId: String) async throws -> Program?
    
    /// Fetch today's plan for a user
    func fetchTodayPlan(for userId: String) async throws -> TodayPlan
}

