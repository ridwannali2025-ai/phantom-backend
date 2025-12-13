//
//  SupabaseProgramService.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Supabase-backed implementation of ProgramService for production use
/// Fetches program data from Supabase Postgres database via REST API
final class SupabaseProgramService: ProgramService {
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
    
    // MARK: - ProgramService
    
    func fetchCurrentProgram(for userId: String) async throws -> Program? {
        let query = [
            URLQueryItem(name: "user_id", value: "eq.\(userId)"),
            URLQueryItem(name: "order", value: "created_at.desc"),
            URLQueryItem(name: "limit", value: "1")
        ]
        
        var request = try makeRequest(
            path: "rest/v1/programs",
            method: "GET",
            queryItems: query
        )
        request.setValue("return=representation", forHTTPHeaderField: "Prefer")
        
        let (data, response) = try await session.data(for: request)
        try validate(response: response, data: data)
        
        let decoder = Self.jsonDecoder
        let programs = try decoder.decode([Program].self, from: data)
        return programs.first
    }
    
    func fetchTodayPlan(for userId: String) async throws -> TodayPlan {
        let today = Calendar.current.startOfDay(for: Date())
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        let todayString = formatter.string(from: today)
        
        let query = [
            URLQueryItem(name: "user_id", value: "eq.\(userId)"),
            URLQueryItem(name: "date", value: "eq.\(todayString)"),
            URLQueryItem(name: "order", value: "created_at.desc"),
            URLQueryItem(name: "limit", value: "1")
        ]
        
        var request = try makeRequest(
            path: "rest/v1/today_plans",
            method: "GET",
            queryItems: query
        )
        request.setValue("return=representation", forHTTPHeaderField: "Prefer")
        
        let (data, response) = try await session.data(for: request)
        try validate(response: response, data: data)
        
        let decoder = Self.jsonDecoder
        let plans = try decoder.decode([TodayPlan].self, from: data)
        
        guard let plan = plans.first else {
            throw NSError(domain: "SupabaseProgramService", code: 404, userInfo: [NSLocalizedDescriptionKey: "No plan found for today"])
        }
        
        return plan
    }
    
    // MARK: - Upsert helpers (non-protocol convenience)
    
    @discardableResult
    func upsertProgram(_ program: Program) async throws -> Program {
        let encoder = Self.jsonEncoder
        let payload = try encoder.encode(program)
        
        var request = try makeRequest(
            path: "rest/v1/programs",
            method: "POST",
            body: payload
        )
        request.setValue("return=representation,resolution=merge-duplicates", forHTTPHeaderField: "Prefer")
        
        let (data, response) = try await session.data(for: request)
        try validate(response: response, data: data)
        
        let decoder = Self.jsonDecoder
        let programs = try decoder.decode([Program].self, from: data)
        return programs.first ?? program
    }
    
    @discardableResult
    func upsertTodayPlan(_ plan: TodayPlan) async throws -> TodayPlan {
        let encoder = Self.jsonEncoder
        let payload = try encoder.encode(plan)
        
        var request = try makeRequest(
            path: "rest/v1/today_plans",
            method: "POST",
            body: payload
        )
        request.setValue("return=representation,resolution=merge-duplicates", forHTTPHeaderField: "Prefer")
        
        let (data, response) = try await session.data(for: request)
        try validate(response: response, data: data)
        
        let decoder = Self.jsonDecoder
        let plans = try decoder.decode([TodayPlan].self, from: data)
        return plans.first ?? plan
    }
    
    // MARK: - Request helpers
    
    private func makeRequest(path: String, method: String, queryItems: [URLQueryItem] = [], body: Data? = nil) throws -> URLRequest {
        var components = URLComponents(url: supabaseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        guard let url = components?.url else {
            throw NSError(domain: "SupabaseProgramService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL components"])
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
            throw NSError(domain: "SupabaseProgramService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        guard (200..<300).contains(http.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "SupabaseProgramService", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: message])
        }
    }
    
    private static var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    private static var jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
}
