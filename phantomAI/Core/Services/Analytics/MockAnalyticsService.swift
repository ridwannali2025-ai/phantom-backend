//
//  MockAnalyticsService.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Mock implementation of AnalyticsService for development and previews
/// TODO: Replace with real analytics service (Firebase Analytics, Mixpanel, etc.)
final class MockAnalyticsService: AnalyticsService {
    func track(event: AnalyticsEvent) {
        // TODO: Implement real event tracking (Firebase Analytics, Mixpanel, etc.)
        // For now, just print to console
        print("📊 Analytics Event: \(event.name)")
        if !event.parameters.isEmpty {
            print("   Parameters: \(event.parameters)")
        }
    }
    
    func trackScreen(_ name: String) {
        // TODO: Implement real screen tracking
        // For now, just print to console
        print("📱 Screen View: \(name)")
    }
}

