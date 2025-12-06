//
//  OnboardingCoachHistoryView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingCoachHistoryView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @State private var selection: Bool? = nil   // true = Yes, false = No

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Title & subtitle
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Have you ever worked with a coach before?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("This helps Phantom tailor how much structure and accountability you might want.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 24)

                    // Yes/No options
                    VStack(spacing: 12) {
                        coachOptionRow(
                            title: "Yes",
                            subtitle: "I've worked with a coach or trainer before.",
                            systemImage: "hand.thumbsup.fill",
                            isSelected: selection == true
                        ) {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                selection = true
                            }
                        }

                        coachOptionRow(
                            title: "No",
                            subtitle: "This will be my first time having a coach.",
                            systemImage: "hand.thumbsdown.fill",
                            isSelected: selection == false
                        ) {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                selection = false
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)

                    Spacer()
                        .frame(height: 40)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Bottom-anchored Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: selection != nil
            ) {
                guard let selection else { return }
                onboarding.answers.hasWorkedWithCoach = selection
                onboarding.goToNext()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Prefill from answers if present
            if let stored = onboarding.answers.hasWorkedWithCoach {
                selection = stored
            }
        }
    }

    // MARK: - Subview

    private func coachOptionRow(
        title: String,
        subtitle: String,
        systemImage: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.white : Color(hex: "F7F7F7"))
                        .frame(width: 44, height: 44)

                    Image(systemName: systemImage)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(isSelected ? Color(hex: "A06AFE") : .primary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(isSelected ? Color(hex: "A06AFE") : Color(hex: "F7F7F7"))
            )
            .foregroundColor(isSelected ? .white : .primary)
            .animation(.easeInOut(duration: 0.15), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OnboardingCoachHistoryView()
        .environmentObject(OnboardingViewModel.preview)
}

