//
//  OnboardingExperienceView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Onboarding screen for selecting training experience
struct OnboardingExperienceView: View {
    let selectedExperience: TrainingExperience?
    let onSelectExperience: (TrainingExperience) -> Void
    let onContinue: () -> Void
    let onBack: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            OnboardingHeaderView(
                currentStep: 2,
                totalSteps: 4,
                onBack: onBack
            )
            .padding(.top, 8)
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 8) {
                Text("What's your training experience?")
                    .font(.system(size: 24, weight: .semibold))
                Text("This helps us pick the right difficulty and progressions.")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "8A8A8E"))
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            Spacer(minLength: 24)
            
            // Experience selection cards
            VStack(spacing: 16) {
                card(.beginner,
                     title: "Beginner",
                     subtitle: "New to lifting or returning after a long break.")
                card(.intermediate,
                     title: "Intermediate",
                     subtitle: "Comfortable with the basics, want better structure.")
                card(.advanced,
                     title: "Advanced",
                     subtitle: "Years of training, ready for serious progression.")
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: selectedExperience != nil,
                action: onContinue
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(Color(.systemBackground))
    }
    
    private func card(_ level: TrainingExperience, title: String, subtitle: String) -> some View {
        OnboardingSelectableCard(
            title: title,
            subtitle: subtitle,
            isSelected: selectedExperience == level,
            onTap: { onSelectExperience(level) }
        )
    }
}

#Preview {
    OnboardingExperienceView(
        selectedExperience: nil,
        onSelectExperience: { _ in },
        onContinue: {},
        onBack: nil
    )
}

