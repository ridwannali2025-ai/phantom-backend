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
                // .welcome
                // .primaryGoal
                // .goalTimeline
                // .bodyStats
                // .activityLevel
                // .workoutTime
                // .sleepHours
                // .pastBlockers
                // .equipmentAccess
                // .trainingDays
                // .splitPreference
                // .sessionLength
                // .experienceLevel
                // .fitnessBenchmark
                // .injuries
                // .dietaryNeeds
                // .cookingSkill
                // .recentIntake
                // .foodAversions
                // .coachStyle
                // .connectHealth
                // .aiAnalysis
                // .planSummary
                viewModel.currentStep = .goalTimeline
                // Optionally, for previewing the slider UI specifically:
                viewModel.primaryGoal = .loseFat
            }
    }
}

#Preview {
    OnboardingPreviewHost()
}

