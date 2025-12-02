//
//  PhantomAIApp.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

@main
struct PhantomAIApp: App {
    /// Dependency injection container
    /// Currently using preview (mock services) for development
    /// Uncomment the live container below when ready to use production services
    let container = AppContainer.preview
    
    // Uncomment when ready to use production services:
    // let container = AppContainer.live(config: .init(
    //     supabaseUrl: URL(string: "https://YOUR_PROJECT.supabase.co")!,
    //     supabaseAnonKey: "YOUR_SUPABASE_ANON_KEY",
    //     apiBaseURL: URL(string: "https://your-vercel-backend.vercel.app")!,
    //     mixpanelApiKey: nil // Optional: Add your Mixpanel API key here
    // ))
    
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(\.container, container)
        }
    }
}


