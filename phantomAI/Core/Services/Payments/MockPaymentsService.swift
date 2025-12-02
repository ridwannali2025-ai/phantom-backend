//
//  MockPaymentsService.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Mock implementation of PaymentsService for development and previews
/// TODO: Replace with real payments service (RevenueCat, Stripe, etc.)
final class MockPaymentsService: PaymentsService {
    private var isPremium: Bool = false
    
    func loadOfferings() async throws -> [SubscriptionOffering] {
        // TODO: Implement real offerings loading (RevenueCat, Stripe, etc.)
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Return mock offerings
        return [
            SubscriptionOffering(
                id: "monthly_premium",
                name: "Monthly Premium",
                description: "Access to all premium features",
                price: 9.99,
                currency: "USD",
                duration: .monthly,
                features: ["Unlimited AI chats", "Advanced analytics", "Custom programs"]
            ),
            SubscriptionOffering(
                id: "yearly_premium",
                name: "Yearly Premium",
                description: "Best value - Save 20%",
                price: 95.99,
                currency: "USD",
                duration: .yearly,
                features: ["Unlimited AI chats", "Advanced analytics", "Custom programs", "Priority support"]
            )
        ]
    }
    
    func purchase(_ offering: SubscriptionOffering) async throws {
        // TODO: Implement real purchase flow (RevenueCat, Stripe, App Store, etc.)
        // Simulate purchase processing
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Mock successful purchase
        isPremium = true
    }
    
    func isPremiumUser() async throws -> Bool {
        // TODO: Implement real premium status check
        // Simulate network delay
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        
        return isPremium
    }
}

