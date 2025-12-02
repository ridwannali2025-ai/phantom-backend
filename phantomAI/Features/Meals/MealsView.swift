//
//  MealsView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Meals tab view showing meal plans and nutrition
struct MealsView: View {
    @StateObject private var viewModel = MealsViewModel()
    @Environment(\.container) private var container
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView("Loading meals...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                case .loaded:
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Meals")
                                .font(.largeTitle)
                                .bold()
                                .padding(.horizontal)
                            
                            // TODO: Add meal plans UI
                            Text("Meal plans will appear here")
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
            .navigationTitle("Meals")
            .task {
                await viewModel.load(container: container)
            }
        }
    }
}

#Preview {
    MealsView()
        .environment(\.container, AppContainer.preview)
}


