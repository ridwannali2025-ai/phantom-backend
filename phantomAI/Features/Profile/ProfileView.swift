//
//  ProfileView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Profile tab view showing user profile and settings
struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.container) private var container
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView("Loading profile...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                case .loaded:
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Profile")
                                .font(.largeTitle)
                                .bold()
                                .padding(.horizontal)
                            
                            // TODO: Add profile content
                            Text("Profile information will appear here")
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
            .navigationTitle("Profile")
            .task {
                await viewModel.load(container: container)
            }
        }
    }
}

#Preview {
    ProfileView()
        .environment(\.container, AppContainer.preview)
}


