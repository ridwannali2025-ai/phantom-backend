//
//  AppEnvironment.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Environment key for accessing the app container
private struct AppContainerKey: EnvironmentKey {
    static let defaultValue: AppContainer = AppContainer.preview
}

/// Environment values extension to access the app container
extension EnvironmentValues {
    /// Access the app container via environment
    var container: AppContainer {
        get { self[AppContainerKey.self] }
        set { self[AppContainerKey.self] = newValue }
    }
}


