//
//  OnboardingActivityLevelView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingActivityLevelView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @State private var selectedActivity: ActivityLevel? = nil

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title & subtitle with generous spacing
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Outside of workouts, how active are you?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("This affects how much you can eat and still make progress.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 32)
                    .padding(.horizontal, 24)

                    // Activity level cards
                    VStack(spacing: 12) {
                        ForEach(ActivityLevel.allCases, id: \.self) { level in
                            activityCard(for: level)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Bottom-anchored Continue button
            Button(action: {
                guard let selectedActivity else { return }
                // Save into central model
                onboarding.answers.activityLevel = selectedActivity
                onboarding.goToNext()
            }) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .background(
                        Group {
                            if selectedActivity != nil {
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(hex: "A06AFE"),
                                        Color(hex: "7366FF")
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            } else {
                                Color(hex: "D1D1D6")
                            }
                        }
                    )
                    .clipShape(Capsule())
            }
            .disabled(selectedActivity == nil)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Prefill activity level if user navigates back
            if let savedActivity = onboarding.answers.activityLevel {
                selectedActivity = savedActivity
            }
        }
    }
    
    // MARK: - Activity Card
    
    private func activityCard(for level: ActivityLevel) -> some View {
        let isSelected = selectedActivity == level
        
        return Button(action: {
            // Smooth animation on selection
            withAnimation(.easeInOut(duration: 0.15)) {
                selectedActivity = level
            }
        }) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: level.symbolName)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .white : Color(hex: "A06AFE"))
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.white.opacity(0.2) : Color(hex: "A06AFE").opacity(0.1))
                    )
                
                // Title and description
                VStack(alignment: .leading, spacing: 4) {
                    Text(level.title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .primary)
                    
                    Text(level.description)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(height: 80)
            .frame(maxWidth: .infinity)
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
            .scaleEffect(isSelected ? 1.02 : 1.0)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    OnboardingActivityLevelView()
        .environmentObject(OnboardingViewModel.preview)
}
