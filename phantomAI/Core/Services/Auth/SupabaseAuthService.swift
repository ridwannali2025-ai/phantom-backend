//
//  SupabaseAuthService.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Supabase-backed implementation of AuthService for production use
/// Handles authentication via Supabase Auth REST API
final class SupabaseAuthService: AuthService {
    private let supabaseUrl: URL
    private let supabaseAnonKey: String
    private(set) var currentUserId: String?
    
    init(config: AppConfig) {
        self.supabaseUrl = config.supabaseUrl
        self.supabaseAnonKey = config.supabaseAnonKey
        // TODO: Load current session from Keychain or UserDefaults on init
        // TODO: Initialize Supabase client with URL and anon key
    }
    
    func signIn(email: String, password: String) async throws {
        // TODO: Implement Supabase Auth sign in
        // 1. Construct POST request to {supabaseUrl}/auth/v1/token?grant_type=password
        // 2. Include email and password in request body
        // 3. Add Authorization header with Bearer {supabaseAnonKey}
        // 4. Parse response to get access_token and user data
        // 5. Store tokens securely in Keychain
        // 6. Set currentUserId from response
        
        // Stub implementation
        throw NSError(domain: "SupabaseAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented: Supabase sign in"])
    }
    
    func signUp(email: String, password: String) async throws {
        // TODO: Implement Supabase Auth sign up
        // 1. Construct POST request to {supabaseUrl}/auth/v1/signup
        // 2. Include email and password in request body
        // 3. Add Authorization header with Bearer {supabaseAnonKey}
        // 4. Parse response to get access_token and user data
        // 5. Store tokens securely in Keychain
        // 6. Set currentUserId from response
        
        // Stub implementation
        throw NSError(domain: "SupabaseAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented: Supabase sign up"])
    }
    
    func signOut() async throws {
        // TODO: Implement Supabase Auth sign out
        // 1. Construct POST request to {supabaseUrl}/auth/v1/logout
        // 2. Include access_token in Authorization header
        // 3. Clear tokens from Keychain
        // 4. Set currentUserId to nil
        
        // Stub implementation
        currentUserId = nil
    }
}

