//
//  WorkoutsView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Workouts tab view showing workout history and plans
struct WorkoutsView: View {
    @StateObject private var viewModel = WorkoutsViewModel()
    @Environment(\.container) private var container
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView("Loading workouts...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                case .loaded:
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Workouts")
                                .font(.largeTitle)
                                .bold()
                                .padding(.horizontal)
                            
                            // TODO: Add workout sessions list
                            Text("Workout sessions will appear here")
                                .padding()
                        }
                    }
                    
                case .error(let message):
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text("Error")
                            .font(.headline)
                        Text(message)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button("Retry") {
                            Task {
                                await viewModel.load(container: container)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Workouts")
            .task {
                await viewModel.load(container: container)
            }
        }
    }
}

#Preview {
    WorkoutsView()
        .environment(\.container, AppContainer.preview)
}

