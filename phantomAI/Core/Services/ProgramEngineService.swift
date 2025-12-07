//
//  ProgramEngineService.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

struct ProgramEngineService {
    struct APIResponse: Codable {
        let caloriesPerDay: Int
        let proteinGrams: Int
        let carbsGrams: Int
        let fatsGrams: Int
        let trainingSplitTitle: String
        let trainingSplitSubtitle: String
    }

    enum ProgramEngineError: Error {
        case invalidURL
        case badStatusCode(Int)
        case decodingFailed
    }

    // TODO: replace with your real backend URL (Vercel, Supabase edge func, etc.)
    private let baseURLString = "https://YOUR_PROGRAM_ENGINE_URL_HERE/api/program"

    func generatePlan(from request: ProgramRequest) async throws -> GeneratedPlan {
        guard let url = URL(string: baseURLString) else {
            throw ProgramEngineError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        urlRequest.httpBody = try encoder.encode(request)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw ProgramEngineError.badStatusCode(http.statusCode)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let apiResponse = try? decoder.decode(APIResponse.self, from: data) else {
            throw ProgramEngineError.decodingFailed
        }

        return GeneratedPlan(
            caloriesPerDay: apiResponse.caloriesPerDay,
            proteinGrams: apiResponse.proteinGrams,
            carbsGrams: apiResponse.carbsGrams,
            fatsGrams: apiResponse.fatsGrams,
            trainingSplitTitle: apiResponse.trainingSplitTitle,
            trainingSplitSubtitle: apiResponse.trainingSplitSubtitle
        )
    }
}

