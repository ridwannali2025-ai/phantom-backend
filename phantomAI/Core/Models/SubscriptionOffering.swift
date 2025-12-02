//
//  SubscriptionOffering.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Represents a subscription offering available for purchase
struct SubscriptionOffering: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let currency: String
    let duration: SubscriptionDuration
    let features: [String]
    
    enum SubscriptionDuration: String, Codable {
        case monthly
        case yearly
        case lifetime
    }
}


