//
//  WorkoutsViewModel.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// View model for Workouts view
/// Manages state and business logic for workout sessions
@MainActor
final class WorkoutsViewModel: ObservableObject {
    /// View state
    enum State {
        case idle
        case loading
        case loaded
        case error(String)
    }
    
    @Published var state: State = .idle
    
    /// Load workout sessions
    func load(container: AppContainer) async {
        state = .loading
        
        do {
            // Get current user ID
            guard let userId = container.authService.currentUserId else {
                state = .error("Not signed in")
                return
            }
            
            // Fetch recent sessions
            _ = try await container.workoutService.fetchRecentSessions(for: userId)
            
            // Track screen view
            container.analyticsService.trackScreen("Workouts")
            
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}


