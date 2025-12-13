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
    private let session: URLSession
    private let sessionStore: SupabaseSessionStore
    private var accessToken: String?
    private(set) var currentUserId: String?
    
    init(config: AppConfig, session: URLSession = .shared, sessionStore: SupabaseSessionStore = .shared) {
        self.supabaseUrl = config.supabaseUrl
        self.supabaseAnonKey = config.supabaseAnonKey
        self.session = session
        self.sessionStore = sessionStore
        // TODO: Load current session and access token from secure storage
    }
    
    func signIn(email: String, password: String) async throws {
        let url = supabaseUrl.appendingPathComponent("auth/v1/token")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "grant_type", value: "password")]
        guard let finalURL = components?.url else {
            throw NSError(domain: "SupabaseAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid sign-in URL"])
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(supabaseAnonKey)", forHTTPHeaderField: "Authorization")
        request.setValue(supabaseAnonKey, forHTTPHeaderField: "apikey")
        let body = ["email": email, "password": password]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, response) = try await session.data(for: request)
        try validate(response: response, data: data, operation: "signIn")
        
        let auth = try Self.decoder.decode(AuthResponse.self, from: data)
        let access = auth.accessToken ?? auth.session?.accessToken
        let refresh = auth.refreshToken ?? auth.session?.refreshToken
        let userId = auth.user?.id
        self.accessToken = access
        self.currentUserId = userId
        sessionStore.update(accessToken: access, refreshToken: refresh, userId: userId)
        // TODO: Persist accessToken securely for subsequent Supabase requests
    }
    
    func signUp(email: String, password: String) async throws {
        let url = supabaseUrl.appendingPathComponent("auth/v1/signup")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(supabaseAnonKey)", forHTTPHeaderField: "Authorization")
        request.setValue(supabaseAnonKey, forHTTPHeaderField: "apikey")
        let body = ["email": email, "password": password]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, response) = try await session.data(for: request)
        try validate(response: response, data: data, operation: "signUp")
        
        let auth = try Self.decoder.decode(AuthResponse.self, from: data)
        let access = auth.accessToken ?? auth.session?.accessToken
        let refresh = auth.refreshToken ?? auth.session?.refreshToken
        let userId = auth.user?.id
        self.accessToken = access
        self.currentUserId = userId
        sessionStore.update(accessToken: access, refreshToken: refresh, userId: userId)
        // TODO: Persist accessToken securely for subsequent Supabase requests
    }
    
    func signOut() async throws {
        let url = supabaseUrl.appendingPathComponent("auth/v1/logout")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = try sessionStore.requireAccessToken()
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue(supabaseAnonKey, forHTTPHeaderField: "apikey")
        
        let (data, response) = try await session.data(for: request)
        try validate(response: response, data: data, operation: "signOut")
        
        // Clear local session
        currentUserId = nil
        accessToken = nil
        sessionStore.clear()
        // TODO: Remove persisted tokens from secure storage
    }
    
    // MARK: - Helpers
    
    private func validate(response: URLResponse, data: Data, operation: String) throws {
        guard let http = response as? HTTPURLResponse else {
            throw NSError(domain: "SupabaseAuthService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid response for \(operation)"])
        }
        guard (200..<300).contains(http.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "SupabaseAuthService", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: message])
        }
    }
    
    private struct AuthResponse: Codable {
        struct Session: Codable {
            let accessToken: String?
            let tokenType: String?
            let refreshToken: String?
        }
        
        struct User: Codable {
            let id: String?
        }
        
        let accessToken: String?
        let refreshToken: String?
        let user: User?
        let session: Session?
    }
    
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
