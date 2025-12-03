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
    @State private var showingEmailAuth = false
    @State private var email = ""
    @State private var password = ""
    
    let onSignedIn: () -> Void
    
    init(container: AppContainer, onSignedIn: @escaping () -> Void) {
        self.onSignedIn = onSignedIn
        _viewModel = StateObject(wrappedValue: AuthViewModel(authService: container.authService))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                // Title
                Text("Sign In or Sign Up")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal, 32)
                
                Spacer()
                
                // Auth buttons
                VStack(spacing: 16) {
                    if !showingEmailAuth {
                        // Social auth buttons
                        Button(action: {
                            Task {
                                await viewModel.signInWithApple()
                            }
                        }) {
                            HStack {
                                Image(systemName: "apple.logo")
                                Text("Continue with Apple")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            Task {
                                await viewModel.signInWithGoogle()
                            }
                        }) {
                            HStack {
                                Image(systemName: "globe")
                                Text("Continue with Google")
                            }
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            showingEmailAuth = true
                        }) {
                            HStack {
                                Image(systemName: "envelope")
                                Text("Continue with Email")
                            }
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor.opacity(0.1))
                            .cornerRadius(12)
                        }
                    } else {
                        // Email auth form
                        VStack(spacing: 16) {
                            TextField("Email", text: $email)
                                .textFieldStyle(.roundedBorder)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                            
                            SecureField("Password", text: $password)
                                .textFieldStyle(.roundedBorder)
                            
                            Button(action: {
                                Task {
                                    await viewModel.signInWithEmail(email: email, password: password)
                                }
                            }) {
                                Text("Sign In")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.accentColor)
                                    .cornerRadius(12)
                            }
                            
                            Button(action: {
                                showingEmailAuth = false
                            }) {
                                Text("Back")
                                    .font(.subheadline)
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .navigationTitle("Authentication")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: viewModel.state) { oldValue, newValue in
                if case .signedIn = newValue {
                    onSignedIn()
                }
            }
        }
    }
}

#Preview {
    AuthView(container: AppContainer.preview) {
        print("Signed in")
    }
}


