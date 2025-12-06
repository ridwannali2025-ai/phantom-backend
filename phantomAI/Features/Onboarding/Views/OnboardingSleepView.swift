//
//  OnboardingSleepView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingSleepView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @State private var selectedSleep: Double? = nil
    
    // Sleep hour options
    private let sleepOptions: [(hours: Double, title: String, subtitle: String)] = [
        (5.0, "5 hours or less", "Most nights I get 5 hours or less"),
        (6.0, "About 6 hours", "Most nights I get ~6 hours"),
        (7.0, "About 7 hours", "Most nights I get ~7 hours"),
        (8.0, "8+ hours", "Most nights I get 8+ hours")
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title & subtitle with generous spacing
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Sleep")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("On average, how many hours do you sleep per night?")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 32)
                    .padding(.horizontal, 24)

                    // Sleep hours selection cards
                    VStack(spacing: 12) {
                        ForEach(sleepOptions, id: \.hours) { option in
                            sleepCard(hours: option.hours, title: option.title, subtitle: option.subtitle)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Bottom-anchored Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: selectedSleep != nil,
                action: {
                    guard let selectedSleep else { return }
                    onboarding.answers.sleepHours = selectedSleep
                    onboarding.goToNext()
                }
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Prefill sleep hours if user navigates back
            if let savedSleep = onboarding.answers.sleepHours {
                selectedSleep = savedSleep
            }
        }
    }
    
    // MARK: - Sleep Card
    
    private func sleepCard(hours: Double, title: String, subtitle: String) -> some View {
        let isSelected = selectedSleep == hours
        
        return OnboardingSelectableCard(
            title: title,
            subtitle: subtitle,
            isSelected: isSelected,
            onTap: {
                // Smooth animation on selection
                withAnimation(.easeInOut(duration: 0.15)) {
                    selectedSleep = hours
                }
            }
        )
    }
}

#Preview {
    OnboardingSleepView()
        .environmentObject(OnboardingViewModel.preview)
}
