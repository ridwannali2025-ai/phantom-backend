//
//  OnboardingWorkoutTimeView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingWorkoutTimeView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @State private var selectedTime: WorkoutTime? = nil

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title & subtitle with generous spacing
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Workout Time")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("When do you usually prefer to train?")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 32)
                    .padding(.horizontal, 24)

                    // Workout time selection cards
                    VStack(spacing: 12) {
                        ForEach(WorkoutTime.allCases) { time in
                            timeCard(for: time)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Bottom-anchored Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: selectedTime != nil,
                action: {
                    guard let selectedTime else { return }
                    onboarding.answers.workoutTime = selectedTime
                    onboarding.goToNext()
                }
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Prefill time if user navigates back
            if let savedTime = onboarding.answers.workoutTime {
                selectedTime = savedTime
            }
        }
    }
    
    // MARK: - Time Card
    
    private func timeCard(for time: WorkoutTime) -> some View {
        let isSelected = selectedTime == time
        
        return OnboardingSelectableCard(
            title: time.rawValue,
            subtitle: subtitleForTime(time),
            isSelected: isSelected,
            onTap: {
                // Smooth animation on selection
                withAnimation(.easeInOut(duration: 0.15)) {
                    selectedTime = time
                }
            }
        )
    }
    
    // MARK: - Subtitle Helper
    
    private func subtitleForTime(_ time: WorkoutTime) -> String {
        switch time {
        case .morning:
            return "Before work or school"
        case .lunch:
            return "Mid-day sessions"
        case .evening:
            return "After work or at night"
        case .flexible:
            return "I'm flexible"
        }
    }
}

#Preview {
    OnboardingWorkoutTimeView()
        .environmentObject(OnboardingViewModel.preview)
}
