//
//  AuthService.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Protocol for authentication service
/// Handles user sign in, sign up, sign out, and current user state
protocol AuthService {
    /// Sign in with email and password
    func signIn(email: String, password: String) async throws
    
    /// Sign up with email and password
    func signUp(email: String, password: String) async throws
    
    /// Sign out the current user
    func signOut() async throws
    
    /// Current authenticated user ID, nil if not signed in
    var currentUserId: String? { get }
}

