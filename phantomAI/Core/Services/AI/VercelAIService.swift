//
//  VercelAIService.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Vercel-hosted API implementation of AIService for production use
/// Communicates with Vercel backend API endpoints for AI functionality
final class VercelAIService: AIService {
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func buildProgram(for request: ProgramRequest) async throws -> Program {
        // TODO: Implement Vercel API call to build program
        // 1. Construct POST request to {baseURL}/api/build-program
        // 2. Encode ProgramRequest to JSON and include in request body
        // 3. Add Content-Type: application/json header
        // 4. Make async network request using URLSession
        // 5. Parse JSON response and decode to Program model
        // 6. Handle errors appropriately
        
        // Stub implementation
        throw NSError(domain: "VercelAIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented: Build program via Vercel API"])
    }
    
    func chat(messages: [AIMessage]) async throws -> [AIMessage] {
        // TODO: Implement Vercel API call for chat
        // 1. Construct POST request to {baseURL}/api/chat
        // 2. Encode messages array to JSON and include in request body
        // 3. Add Content-Type: application/json header
        // 4. Make async network request using URLSession
        // 5. Parse JSON response and decode to [AIMessage]
        // 6. Return original messages + new AI response messages
        // 7. Handle errors appropriately
        
        // Stub implementation
        throw NSError(domain: "VercelAIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented: Chat via Vercel API"])
    }
}

