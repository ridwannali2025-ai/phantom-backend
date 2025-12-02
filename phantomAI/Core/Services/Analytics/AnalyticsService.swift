//
//  AnalyticsService.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Protocol for analytics service
/// Handles tracking events and screen views
protocol AnalyticsService {
    /// Track a custom analytics event
    func track(event: AnalyticsEvent)
    
    /// Track a screen view
    func trackScreen(_ name: String)
}

