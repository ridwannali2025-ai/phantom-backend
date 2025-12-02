//
//  TodayView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Today tab view showing today's plan and activities
struct TodayView: View {
    @StateObject private var viewModel = TodayViewModel()
    @Environment(\.container) private var container
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView("Loading today's plan...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                case .loaded:
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Today's Plan")
                                .font(.largeTitle)
                                .bold()
                                .padding(.horizontal)
                            
                            // TODO: Add today's plan content
                            Text("Today's plan will appear here")
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
            .navigationTitle("Today")
            .task {
                await viewModel.load(container: container)
            }
        }
    }
}

#Preview {
    TodayView()
        .environment(\.container, AppContainer.preview)
}

