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
            case .primaryGoal:
                // Map to legacy goal view for now
                OnboardingGoalView(
                    selectedGoal: viewModel.answers.goal,
                    onSelectGoal: { viewModel.selectGoal($0) },
                    onContinue: { viewModel.goToNextStep() },
                    onBack: nil
                )
                
            case .trainingDaysPerWeek:
                OnboardingScheduleView(
                    selectedDays: viewModel.answers.trainingDaysPerWeek,
                    onSelectDays: { viewModel.selectTrainingDays($0) },
                    onContinue: { viewModel.goToNextStep() },
                    onBack: { viewModel.goToPreviousStep() }
                )
                
            case .trainingExperience:
                OnboardingExperienceView(
                    selectedExperience: viewModel.answers.trainingExperience,
                    onSelectExperience: { viewModel.selectExperience($0) },
                    onContinue: { viewModel.goToNextStep() },
                    onBack: { viewModel.goToPreviousStep() }
                )
                
            case .processing:
                ProgramBuildingView(onFinished: {
                    // Mark onboarding as completed and finish
                    viewModel.completeOnboarding(onFinished: onFinished)
                })
                
            default:
                // Placeholder for unimplemented steps
                VStack(spacing: 24) {
                    Text("Onboarding step: \(viewModel.currentStep.rawValue)")
                        .font(.title3)
                    
                    PrimaryContinueButton(
                        title: "Continue",
                        isEnabled: true,
                        action: { viewModel.goToNextStep() }
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
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

