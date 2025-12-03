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
        
        // TODO: Integrate real Supabase + Sign in with Apple
        // 1. Request Apple ID credential
        // 2. Exchange credential for Supabase token
        // 3. Set currentUserId in authService
        
        try? await Task.sleep(nanoseconds: 400_000_000) // small delay
        state = .signedIn
    }
    
    /// Sign in with Google
    func signInWithGoogle() async {
        state = .loading
        
        // TODO: Integrate real Supabase + Sign in with Google
        // 1. Request Google OAuth credential
        // 2. Exchange credential for Supabase token
        // 3. Set currentUserId in authService
        
        try? await Task.sleep(nanoseconds: 400_000_000) // small delay
        state = .signedIn
    }
    
    /// Sign in with email and password
    func signInWithEmail(email: String, password: String) async {
        state = .loading
        
        // TODO: Integrate real Supabase email/password authentication
        // For now, simulate success
        try? await Task.sleep(nanoseconds: 400_000_000) // small delay
        state = .signedIn
    }
}

