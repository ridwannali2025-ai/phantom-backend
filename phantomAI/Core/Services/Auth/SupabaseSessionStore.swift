//
//  SupabaseSessionStore.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Simple in-memory holder for Supabase session tokens
final class SupabaseSessionStore {
    static let shared = SupabaseSessionStore()
    
    private(set) var accessToken: String?
    private(set) var refreshToken: String?
    private(set) var userId: String?
    
    func update(accessToken: String?, refreshToken: String?, userId: String?) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.userId = userId
    }
    
    func clear() {
        accessToken = nil
        refreshToken = nil
        userId = nil
    }
    
    func requireAccessToken() throws -> String {
        if let token = accessToken {
            return token
        }
        throw NSError(domain: "SupabaseSessionStore", code: -10, userInfo: [NSLocalizedDescriptionKey: "Missing Supabase access token; user must sign in"])
    }
}
