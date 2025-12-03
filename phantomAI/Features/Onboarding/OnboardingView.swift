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
        Group {
            switch viewModel.currentStep {
            case 0:
                OnboardingGoalView(
                    selectedGoal: viewModel.answers.goal,
                    onSelectGoal: { viewModel.selectGoal($0) },
                    onContinue: { viewModel.goToNextStep() }
                )
                
            default:
                // For now, show a simple placeholder Text("Next screen coming soon")
                VStack {
                    Spacer()
                    Text("Next onboarding step")
                        .font(.title2)
                    Spacer()
                }
                .background(Color(.systemBackground))
            }
        }
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

