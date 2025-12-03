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
        VStack(spacing: 24) {
            // Header
            OnboardingHeaderView(
                currentStep: .primaryGoal,
                onBack: onBack
            )
            
            // Title
            Text("What's your main fitness goal?")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(Color(hex: "1D1D1F"))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
            
            // Subtitle
            Text("We'll customize your program based on your primary objective")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "8A8A8E"))
                .padding(.top, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
            
            // Goal selection cards
            ScrollView {
                VStack(spacing: 18) {
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
            .padding(.bottom, 24)
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

