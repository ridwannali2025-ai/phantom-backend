//
//  MealsViewModel.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation
import Combine

/// View model for Meals view
/// Manages state and business logic for meal plans
@MainActor
final class MealsViewModel: ObservableObject {
    /// View state
    enum State {
        case idle
        case loading
        case loaded
        case error(String)
    }
    
    @Published var state: State = .idle
    
    /// Load meal plans
    func load(container: AppContainer) async {
        state = .loading
        
        do {
            // Get current user ID
            guard let userId = container.authService.currentUserId else {
                state = .error("Not signed in")
                return
            }
            
            // Fetch today's plan which includes meals
            _ = try await container.programService.fetchTodayPlan(for: userId)
            
            // Track screen view
            container.analyticsService.trackScreen("Meals")
            
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}


