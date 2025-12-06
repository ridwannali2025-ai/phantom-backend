//
//  OnboardingPrimaryGoalView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingPrimaryGoalView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @State private var selectedGoal: PrimaryGoal? = nil

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title & subtitle with generous spacing
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What is your #1 fitness goal right now?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("We'll customize your program based on your primary objective.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 32)

                    // Visual pill selector with generous spacing
                    VStack(spacing: 12) {
                        ForEach(PrimaryGoal.allCases, id: \.self) { goal in
                            goalCard(for: goal)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Bottom-anchored Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: selectedGoal != nil,
                action: {
                    guard let selectedGoal else { return }
                    onboarding.answers.primaryGoal = selectedGoal
                    onboarding.goToNext()
                }
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Prefill goal if user navigates back
            if let savedGoal = onboarding.answers.primaryGoal {
                selectedGoal = savedGoal
            }
        }
    }

    private func goalCard(for goal: PrimaryGoal) -> some View {
        let isSelected = selectedGoal == goal

        return OnboardingSelectableCard(
            isSelected: isSelected,
            content: {
                HStack(spacing: 12) {
                    // SF Symbol icon on the left in fixed-width frame for alignment
                    Image(systemName: goal.symbolName)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .secondary)
                        .baselineOffset(goal.symbolName == "dumbbell" ? 2 : 0)
                        .frame(width: 30, alignment: .center)
                    
                    // Title text
                    Text(goal.title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .primary)
                    
                    // Spacer to push content left-aligned
                    Spacer()
        }
                .padding(.horizontal, 20)
                .frame(height: 60)
            },
            onTap: {
                // Smooth animation on selection
                withAnimation(.easeInOut(duration: 0.15)) {
                    selectedGoal = goal
                }
            }
        )
    }
}

#Preview {
    OnboardingPrimaryGoalView()
        .environmentObject(OnboardingViewModel.preview)
}
