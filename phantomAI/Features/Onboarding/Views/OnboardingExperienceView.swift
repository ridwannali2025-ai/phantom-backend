//
//  OnboardingExperienceView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Onboarding screen for selecting training experience
struct OnboardingExperienceView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @State private var selectedExperience: TrainingExperience? = nil

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title & subtitle with generous spacing
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How experienced are you?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("This helps us set the right intensity and volume for your program.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 32)
                    .padding(.horizontal, 24)

                    // Experience selection pills
                    VStack(spacing: 12) {
                        experiencePill(.beginner, label: "New to this", description: "Just starting out with lifting")
                        experiencePill(.intermediate, label: "Trained a bit", description: "Some experience with weights")
                        experiencePill(.advanced, label: "Experienced lifter", description: "Years of training under your belt")
                    }
                    .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Bottom-anchored Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: selectedExperience != nil,
                action: {
                    guard let selectedExperience else { return }
                    onboarding.answers.trainingExperience = selectedExperience
                    onboarding.goToNext()
                }
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Prefill experience if user navigates back
            if let savedExperience = onboarding.answers.trainingExperience {
                selectedExperience = savedExperience
            }
        }
    }
    
    // MARK: - Experience Pill
    
    private func experiencePill(_ experience: TrainingExperience, label: String, description: String) -> some View {
        let isSelected = selectedExperience == experience
        
        return Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) {
                selectedExperience = experience
            }
        }) {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isSelected ? Color(hex: "A06AFE") : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(isSelected ? Color.clear : Color(hex: "E5E5EA"), lineWidth: 1)
                    )
            )
            .shadow(
                color: isSelected ? Color(hex: "A06AFE").opacity(0.25) : Color.black.opacity(0.05),
                radius: isSelected ? 24 : 8,
                x: 0,
                y: isSelected ? 8 : 2
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    OnboardingExperienceView()
        .environmentObject(OnboardingViewModel.preview)
}

