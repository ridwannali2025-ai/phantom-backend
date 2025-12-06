//
//  OnboardingSignUpView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingSignUpView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Title
                    Text("Save your progress")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 60)
                        .padding(.horizontal, 24)
                    
                    // Subtitle (optional, can be hidden if not in design)
                    Text("Create a free account so Phantom can save your workouts, meals, and AI coach across devices.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 8)
                        .padding(.horizontal, 24)
                    
                    // Spacer to push content downward naturally
                    Spacer(minLength: 0)
                    
                    // Buttons - directly on white background, no card container
                    VStack(spacing: 16) {
                        // Apple button
                        Button(action: handleAppleSignIn) {
                            HStack(spacing: 12) {
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 20, weight: .regular))

                                Text("Sign in with Apple")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.black)
                            )
                        }
                        .buttonStyle(.plain)

                        // Google button
                        Button(action: handleGoogleSignIn) {
                            HStack(spacing: 12) {
                                // Replace with real Google asset later if available
                                Image(systemName: "globe")
                                    .font(.system(size: 18, weight: .regular))

                                Text("Sign in with Google")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.06), radius: 18, x: 0, y: 10)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 140)
                    .padding(.horizontal, 24)
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .background(Color.white.ignoresSafeArea())
    }

    // MARK: - Actions

    private func handleAppleSignIn() {
        // Simulate sign-in success
        Task {
            // Simulate network delay
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            
            await MainActor.run {
                // Mark as authenticated and onboarding complete
                appState.isAuthenticated = true
                appState.hasCompletedOnboarding = true
                
                // Navigate to paywall
                onboarding.goToNext()
            }
        }
    }

    private func handleGoogleSignIn() {
        // Simulate sign-in success
        Task {
            // Simulate network delay
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            
            await MainActor.run {
                // Mark as authenticated and onboarding complete
                appState.isAuthenticated = true
                appState.hasCompletedOnboarding = true
                
                // Navigate to paywall
                onboarding.goToNext()
            }
        }
    }
}

#Preview {
    OnboardingSignUpView()
        .environmentObject(OnboardingViewModel.preview)
        .environmentObject(AppState())
}

