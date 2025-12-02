//
//  PaymentsService.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Protocol for payments service
/// Handles subscription offerings and premium status
protocol PaymentsService {
    /// Load available subscription offerings
    func loadOfferings() async throws -> [SubscriptionOffering]
    
    /// Purchase a subscription offering
    func purchase(_ offering: SubscriptionOffering) async throws
    
    /// Check if the current user has premium access
    func isPremiumUser() async throws -> Bool
}

