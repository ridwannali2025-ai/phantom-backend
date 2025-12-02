//
//  ProfileViewModel.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// View model for Profile view
/// Manages state and business logic for user profile
@MainActor
final class ProfileViewModel: ObservableObject {
    /// View state
    enum State {
        case idle
        case loading
        case loaded
        case error(String)
    }
    
    @Published var state: State = .idle
    
    /// Load profile data
    func load(container: AppContainer) async {
        state = .loading
        
        do {
            // Track screen view
            container.analyticsService.trackScreen("Profile")
            
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

