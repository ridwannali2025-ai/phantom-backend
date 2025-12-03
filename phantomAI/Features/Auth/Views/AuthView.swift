//
//  AuthView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Authentication view for sign in and sign up
struct AuthView: View {
    @Environment(\.container) private var container
    @StateObject private var viewModel: AuthViewModel
    
    let onSignedIn: () -> Void
    
    init(container: AppContainer, onSignedIn: @escaping () -> Void) {
        self.onSignedIn = onSignedIn
        _viewModel = StateObject(wrappedValue: AuthViewModel(authService: container.authService))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Title
            Text("Sign in to continue")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 12)
            
            // Subtitle
            Text("Create an account or sign in to sync your training and progress.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            
            // Auth buttons
            VStack(spacing: 16) {
                // Continue with Apple
                Button(action: {
                    Task {
                        await viewModel.signInWithApple()
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "apple.logo")
                        Text("Continue with Apple")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.black)
                    .cornerRadius(12)
                }
                
                // Continue with Google
                Button(action: {
                    Task {
                        await viewModel.signInWithGoogle()
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "globe")
                        Text("Continue with Google")
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .cornerRadius(12)
                }
                
                // Continue with Email
                Button(action: {
                    Task {
                        await viewModel.signInWithEmail(email: "test@example.com", password: "password")
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "envelope")
                        Text("Continue with Email")
                    }
                    .font(.headline)
                    .foregroundColor(.accentColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.accentColor.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .onChange(of: viewModel.state) { oldValue, newValue in
            if case .signedIn = newValue {
                onSignedIn()
            }
        }
    }
}

#Preview {
    AuthView(container: AppContainer.preview) {
        print("Signed in")
    }
}

