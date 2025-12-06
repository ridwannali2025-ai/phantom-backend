//
//  OnboardingPreviewHost.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingPreviewHost: View {
    @StateObject var viewModel = OnboardingViewModel.preview

    var body: some View {
        OnboardingFlowView(viewModel: viewModel)
            .onAppear {
                // Change this to preview different steps:
                // Active steps:
                // .primaryGoal
                // .goalTimeline
                // .bodyStats
                // .weight
                // .age
                // .sex
                // .activityLevel
                // .workoutTime
                // .sleepHours
                // .equipmentAccess
                // .trainingDays
                // .splitPreference
                // .sessionLength
                // .experienceLevel
                // .injuries
                // .dietaryNeeds
                // .foodAversions
                // .planTeaser
                // .aiAnalysis
                // .planSummary
                //
                // Inactive/placeholder steps (not in active flow):
                // .welcome
                // .pastBlockers
                // .fitnessBenchmark
                // .coachStyle
                // .cookingSkill
                // .recentIntake
                // .connectHealth
                viewModel.currentStep = .goalTimeline
                // Optionally, for previewing the slider UI specifically:
                viewModel.answers.primaryGoal = .loseFat
            }
    }
}

#Preview {
    OnboardingPreviewHost()
        .environmentObject(AppState())
}

