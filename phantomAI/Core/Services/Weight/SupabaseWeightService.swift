//
//  SupabaseWeightService.swift
//  phantomAI
//
//  Created for Phase 1 Step 1 smoke test
//

import Foundation

/// Simple service for weight_entries CRUD operations via Supabase
final class SupabaseWeightService {
    private let supabaseUrl: URL
    private let supabaseAnonKey: String
    private let session: URLSession
    private let sessionStore: SupabaseSessionStore
    
    init(config: AppConfig, session: URLSession = .shared, sessionStore: SupabaseSessionStore = .shared) {
        self.supabaseUrl = config.supabaseUrl
        self.supabaseAnonKey = config.supabaseAnonKey
        self.session = session
        self.sessionStore = sessionStore
    }
    
    /// Insert a weight entry for the current user
    func insertWeightEntry(userId: String, date: Date, weight: Double) async throws -> WeightEntry {
        let encoder = Self.jsonEncoder
        let entry = WeightEntry(
            id: UUID(),
            userId: userId,
            date: date,
            weight: weight
        )
        let payload = try encoder.encode(entry)
        
        var request = try makeRequest(
            path: "rest/v1/weight_entries",
            method: "POST",
            body: payload
        )
        request.setValue("return=representation", forHTTPHeaderField: "Prefer")
        
        let (data, response) = try await session.data(for: request)
        try validate(response: response, data: data)
        
        let decoder = Self.jsonDecoder
        let entries = try decoder.decode([WeightEntry].self, from: data)
        return entries.first ?? entry
    }
    
    /// Fetch weight entries for a user
    func fetchWeightEntries(userId: String, limit: Int = 10) async throws -> [WeightEntry] {
        let query = [
            URLQueryItem(name: "user_id", value: "eq.\(userId)"),
            URLQueryItem(name: "order", value: "date.desc"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        let request = try makeRequest(
            path: "rest/v1/weight_entries",
            method: "GET",
            queryItems: query
        )
        
        let (data, response) = try await session.data(for: request)
        try validate(response: response, data: data)
        
        let decoder = Self.jsonDecoder
        return try decoder.decode([WeightEntry].self, from: data)
    }
    
    // MARK: - Request helpers
    
    private func makeRequest(path: String, method: String, queryItems: [URLQueryItem] = [], body: Data? = nil) throws -> URLRequest {
        var components = URLComponents(url: supabaseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        guard let url = components?.url else {
            throw NSError(domain: "SupabaseWeightService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        let token = try sessionStore.requireAccessToken()
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue(supabaseAnonKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
    
    private func validate(response: URLResponse, data: Data) throws {
        guard let http = response as? HTTPURLResponse else {
            throw NSError(domain: "SupabaseWeightService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        guard (200..<300).contains(http.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "SupabaseWeightService", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: message])
        }
    }
    
    private static var jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    
    private static var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}
