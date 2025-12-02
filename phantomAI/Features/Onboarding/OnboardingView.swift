//
//  OnboardingView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Onboarding flow view with placeholder steps
struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel
    
    let onFinished: () -> Void
    
    init(container: AppContainer, onFinished: @escaping () -> Void) {
        self.onFinished = onFinished
        _viewModel = StateObject(wrappedValue: OnboardingViewModel(container: container))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Content area
            TabView(selection: $viewModel.currentStep) {
                // Step 0: Welcome
                OnboardingStepView(
                    title: "Welcome to PhantomAI",
                    description: "Your AI-powered fitness companion",
                    systemImage: "figure.strengthtraining.traditional"
                )
                .tag(0)
                
                // Step 1: Goal selection (placeholder)
                OnboardingStepView(
                    title: "What's your goal?",
                    description: "Goal selection coming soon",
                    systemImage: "target"
                )
                .tag(1)
                
                // Step 2: Experience (placeholder)
                OnboardingStepView(
                    title: "Your experience level?",
                    description: "Experience question coming soon",
                    systemImage: "chart.line.uptrend.xyaxis"
                )
                .tag(2)
                
                // Step 3: Final
                OnboardingStepView(
                    title: "All set!",
                    description: "Let's start your fitness journey",
                    systemImage: "checkmark.circle.fill"
                )
                .tag(3)
            }
            .disabled(true) // Disable swipe, use buttons only
            
            // Navigation buttons
            HStack {
                if viewModel.currentStep > 0 {
                    Button(action: {
                        viewModel.previousStep()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                    }
                } else {
                    Spacer()
                        .frame(maxWidth: .infinity)
                }
                
                Spacer()
                    .frame(width: 16)
                
                Button(action: {
                    if viewModel.currentStep < viewModel.stepsCount - 1 {
                        viewModel.nextStep()
                    } else {
                        viewModel.completeOnboarding(onFinished: onFinished)
                    }
                }) {
                    HStack {
                        Text(viewModel.currentStep < viewModel.stepsCount - 1 ? "Next" : "Get Started")
                        if viewModel.currentStep < viewModel.stepsCount - 1 {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(Color.white)
    }
}

/// Individual onboarding step view
private struct OnboardingStepView: View {
    let title: String
    let description: String
    let systemImage: String
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: systemImage)
                .font(.system(size: 80))
                .foregroundColor(.accentColor)
            
            Text(title)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    OnboardingView(container: AppContainer.preview) {
        print("Onboarding completed")
    }
}

