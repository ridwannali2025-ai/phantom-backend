//
//  ChatViewModel.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation
import Combine

/// View model for Chat view
/// Manages state and business logic for AI chat
@MainActor
final class ChatViewModel: ObservableObject {
    /// View state
    enum State {
        case idle
        case loading
        case loaded
        case error(String)
    }
    
    @Published var state: State = .idle
    
    /// Load chat (initialize if needed)
    func load(container: AppContainer) async {
        state = .loading
        
        // Track screen view
        container.analyticsService.trackScreen("Chat")
        
        state = .loaded
    }
}


