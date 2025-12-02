//
//  TodayViewModel.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// View model for Today view
/// Manages state and business logic for today's plan
@MainActor
final class TodayViewModel: ObservableObject {
    /// View state
    enum State {
        case idle
        case loading
        case loaded
        case error(String)
    }
    
    @Published var state: State = .idle
    
    /// Load today's plan
    func load(container: AppContainer) async {
        state = .loading
        
        do {
            // Get current user ID
            guard let userId = container.authService.currentUserId else {
                state = .error("Not signed in")
                return
            }
            
            // Fetch today's plan
            _ = try await container.programService.fetchTodayPlan(for: userId)
            
            // Track screen view
            container.analyticsService.trackScreen("Today")
            
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}


