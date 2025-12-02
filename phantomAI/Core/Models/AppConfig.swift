//
//  AppConfig.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Application configuration for production services
/// Contains all necessary API keys and URLs for external services
struct AppConfig {
    /// Supabase project URL
    let supabaseUrl: URL
    
    /// Supabase anonymous/public API key
    let supabaseAnonKey: String
    
    /// Base URL for Vercel-hosted AI backend API
    let apiBaseURL: URL
    
    /// Optional Mixpanel API key for analytics
    let mixpanelApiKey: String?
}

