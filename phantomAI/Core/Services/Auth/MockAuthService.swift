//
//  MockAuthService.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Mock implementation of AuthService for development and previews
/// TODO: Replace with real authentication service (Firebase Auth, Auth0, etc.)
final class MockAuthService: AuthService {
    private(set) var currentUserId: String?
    
    /// Initialize with an optional default user ID (useful for previews)
    init(defaultUserId: String? = nil) {
        self.currentUserId = defaultUserId
    }
    
    func signIn(email: String, password: String) async throws {
        // TODO: Implement real authentication
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Mock successful sign in
        currentUserId = "mock_user_\(UUID().uuidString)"
    }
    
    func signUp(email: String, password: String) async throws {
        // TODO: Implement real user registration
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Mock successful sign up
        currentUserId = "mock_user_\(UUID().uuidString)"
    }
    
    func signOut() async throws {
        // TODO: Implement real sign out logic
        // Simulate network delay
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        
        currentUserId = nil
    }
}

