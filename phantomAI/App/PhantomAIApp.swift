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
    /// In production, this would be initialized with real services
    let container = AppContainer.preview
    
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(\.container, container)
        }
    }
}

