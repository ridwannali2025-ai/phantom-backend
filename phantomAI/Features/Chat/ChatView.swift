//
//  ChatView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Chat tab view for AI conversations
struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @Environment(\.container) private var container
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView("Loading chat...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                case .loaded:
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("AI Chat")
                                .font(.largeTitle)
                                .bold()
                                .padding(.horizontal)
                            
                            // TODO: Add chat messages UI
                            Text("Chat messages will appear here")
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
            .navigationTitle("Chat")
            .task {
                await viewModel.load(container: container)
            }
        }
    }
}

#Preview {
    ChatView()
        .environment(\.container, AppContainer.preview)
}


