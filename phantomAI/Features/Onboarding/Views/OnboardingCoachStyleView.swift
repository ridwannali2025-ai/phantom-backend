//
//  OnboardingCoachStyleView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingCoachStyleView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @State private var selectedStyle: CoachStyle? = nil

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title & subtitle with generous spacing
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What's your preferred coaching style?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("This helps us tailor how your AI coach communicates with you.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 32)
                    .padding(.horizontal, 24)

                    // Coach style selection cards
                    VStack(spacing: 12) {
                        ForEach(CoachStyle.allCases) { style in
                            coachStyleCard(for: style)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Bottom-anchored Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: selectedStyle != nil,
                action: {
                    guard let selectedStyle else { return }
                    onboarding.answers.coachStyle = selectedStyle
                    onboarding.goToNext()
                }
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Prefill from existing answers if user navigates back
            if let saved = onboarding.answers.coachStyle {
                selectedStyle = saved
            }
        }
    }
    
    // MARK: - Coach Style Card
    
    private func coachStyleCard(for style: CoachStyle) -> some View {
        let isSelected = selectedStyle == style
        
        return OnboardingSelectableCard(
            title: style.rawValue,
            subtitle: style.description,
            isSelected: isSelected,
            onTap: {
                withAnimation(.easeInOut(duration: 0.15)) {
                    selectedStyle = style
                }
            }
        )
    }
}

#Preview {
    OnboardingCoachStyleView()
        .environmentObject(OnboardingViewModel.preview)
}

