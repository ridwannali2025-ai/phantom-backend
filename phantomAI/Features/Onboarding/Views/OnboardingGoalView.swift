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
    
    var body: some View {
        VStack(spacing: 0) {
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
                        GoalCard(
                            goal: goal,
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
            Button(action: onContinue) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(selectedGoal != nil ? Color.accentColor : Color.gray.opacity(0.3))
                    .cornerRadius(12)
            }
            .disabled(selectedGoal == nil)
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(Color(.systemBackground))
    }
}

/// Individual goal selection card
private struct GoalCard: View {
    let goal: FitnessGoal
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(goal.rawValue)
                    .font(.body)
                    .foregroundColor(isSelected ? .white : .primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.accentColor : Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OnboardingGoalView(
        selectedGoal: nil,
        onSelectGoal: { _ in },
        onContinue: {}
    )
}

