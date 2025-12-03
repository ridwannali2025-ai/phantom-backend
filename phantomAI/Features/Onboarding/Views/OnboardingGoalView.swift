//
//  OnboardingGoalView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Onboarding screen for selecting fitness goal
struct OnboardingGoalView: View {
    let selectedGoal: FitnessGoal?
    let onSelectGoal: (FitnessGoal) -> Void
    let onContinue: () -> Void
    let onBack: (() -> Void)?
    
    init(
        selectedGoal: FitnessGoal?,
        onSelectGoal: @escaping (FitnessGoal) -> Void,
        onContinue: @escaping () -> Void,
        onBack: (() -> Void)? = nil
    ) {
        self.selectedGoal = selectedGoal
        self.onSelectGoal = onSelectGoal
        self.onContinue = onContinue
        self.onBack = onBack
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            OnboardingHeaderView(
                currentStep: 0,
                totalSteps: 4,
                onBack: onBack
            )
            .padding(.top, 8)
            
            Spacer()
            
            // Title
            Text("What's your main fitness goal?")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 12)
            
            // Subtitle
            Text("We'll tailor your program based on this.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            
            // Goal selection cards
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(FitnessGoal.allCases) { goal in
                        OnboardingSelectableCard(
                            title: goal.rawValue,
                            subtitle: nil,
                            isSelected: selectedGoal == goal,
                            onTap: {
                                onSelectGoal(goal)
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
            }
            
            Spacer()
            
            // Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: selectedGoal != nil,
                action: onContinue
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    OnboardingGoalView(
        selectedGoal: nil,
        onSelectGoal: { _ in },
        onContinue: {}
    )
}

