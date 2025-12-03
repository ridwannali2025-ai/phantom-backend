//
//  OnboardingScheduleView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Onboarding screen for selecting training schedule
struct OnboardingScheduleView: View {
    let selectedDays: Int?
    let onSelectDays: (Int) -> Void
    let onContinue: () -> Void
    let onBack: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            OnboardingHeaderView(
                currentStep: .trainingDays,
                onBack: onBack
            )
            
            // Title
            Text("How often can you train?")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(Color(hex: "1D1D1F"))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
            
            // Subtitle
            Text("Be realistic—consistency beats perfection.")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "8A8A8E"))
                .padding(.top, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
            
            // Schedule selection cards
            ScrollView {
                VStack(spacing: 18) {
                    card("3 Days per Week", "Perfect for busy schedules", 3)
                    card("4 Days per Week", "Great balance of training and recovery", 4)
                    card("5 Days per Week", "Dedicated training schedule", 5)
                    card("6+ Days per Week", "High-frequency training", 6)
                }
                .padding(.horizontal, 24)
            }
            
            Spacer()
            
            // Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: selectedDays != nil,
                action: onContinue
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(Color(.systemBackground))
    }
    
    private func card(_ title: String, _ subtitle: String, _ days: Int) -> some View {
        OnboardingSelectableCard(
            title: title,
            subtitle: subtitle,
            isSelected: selectedDays == days,
            onTap: { onSelectDays(days) }
        )
    }
}

#Preview {
    OnboardingScheduleView(
        selectedDays: nil,
        onSelectDays: { _ in },
        onContinue: {},
        onBack: nil
    )
}

