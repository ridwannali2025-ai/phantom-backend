//
//  AppContainer.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Dependency injection container for the app
/// Provides all services needed throughout the application
struct AppContainer {
    let authService: AuthService
    let programService: ProgramService
    let workoutService: WorkoutService
    let aiService: AIService
    let paymentsService: PaymentsService
    let analyticsService: AnalyticsService
    
    /// Preview container with mock services for SwiftUI previews
    static var preview: AppContainer {
        AppContainer(
            authService: MockAuthService(defaultUserId: "preview_user_123"),
            programService: MockProgramService(),
            workoutService: MockWorkoutService(),
            aiService: MockAIService(),
            paymentsService: MockPaymentsService(),
            analyticsService: MockAnalyticsService()
        )
    }
}

