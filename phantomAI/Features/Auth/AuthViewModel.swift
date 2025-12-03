//
//  AuthViewModel.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation
import Combine

/// View model for authentication flow
/// Manages authentication state and methods
@MainActor
final class AuthViewModel: ObservableObject {
    private let authService: AuthService
    
    /// Authentication state
    enum State: Equatable {
        case idle
        case loading
        case signedIn
        case error(String)
    }
    
    @Published var state: State = .idle
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    /// Sign in with Apple
    func signInWithApple() async {
        state = .loading
        
        // TODO: Implement Sign in with Apple
        // 1. Request Apple ID credential
        // 2. Exchange credential for Supabase token
        // 3. Set currentUserId in authService
        
        // Simulate success for now - use dummy credentials to trigger mock sign in
        do {
            try await authService.signIn(email: "apple@example.com", password: "dummy")
            state = .signedIn
        } catch {
            // For development, simulate success even if error occurs
            // TODO: Remove this and handle real errors in production
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            state = .signedIn
        }
    }
    
    /// Sign in with Google
    func signInWithGoogle() async {
        state = .loading
        
        // TODO: Implement Sign in with Google
        // 1. Request Google OAuth credential
        // 2. Exchange credential for Supabase token
        // 3. Set currentUserId in authService
        
        // Simulate success for now - use dummy credentials to trigger mock sign in
        do {
            try await authService.signIn(email: "google@example.com", password: "dummy")
            state = .signedIn
        } catch {
            // For development, simulate success even if error occurs
            // TODO: Remove this and handle real errors in production
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            state = .signedIn
        }
    }
    
    /// Sign in with email and password
    func signInWithEmail(email: String, password: String) async {
        state = .loading
        
        do {
            // Call the auth service (works with mock, will need real implementation for production)
            try await authService.signIn(email: email, password: password)
            state = .signedIn
        } catch {
            // For development with mock service, this shouldn't happen
            // TODO: Handle real errors in production
            state = .error(error.localizedDescription)
        }
    }
}

