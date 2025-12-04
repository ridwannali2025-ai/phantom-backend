//
//  OnboardingFlowView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingFlowView: View {
    @StateObject var viewModel: OnboardingViewModel

    init(viewModel: OnboardingViewModel = OnboardingViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeaderView(
                currentStep: viewModel.currentStep,
                onBack: viewModel.canGoBack ? { viewModel.goBack() } : nil
            )

            contentView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.currentStep {
        case .welcome:
            OnboardingWelcomeView(viewModel: viewModel)

        case .primaryGoal:
            OnboardingPrimaryGoalView()
                .environmentObject(viewModel)

        case .goalTimeline:
            OnboardingGoalTimelineView()
                .environmentObject(viewModel)

        case .bodyStats:
            OnboardingBodyStatsView()
                .environmentObject(viewModel)

        case .weight:
            OnboardingWeightView()
                .environmentObject(viewModel)

        case .age:
            OnboardingAgeView()
                .environmentObject(viewModel)

        case .sex:
            OnboardingSexView()
                .environmentObject(viewModel)

        case .activityLevel:
            OnboardingActivityLevelView()
                .environmentObject(viewModel)

        case .workoutTime:
            OnboardingWorkoutTimeView(viewModel: viewModel)

        case .sleepHours:
            OnboardingSleepView(viewModel: viewModel)

        case .pastBlockers:
            OnboardingPastBlockersView(viewModel: viewModel)

        case .equipmentAccess:
            OnboardingEquipmentView()
                .environmentObject(viewModel)

        case .trainingDays:
            OnboardingTrainingDaysView()
                .environmentObject(viewModel)

        case .splitPreference:
            OnboardingSplitPreferenceView(viewModel: viewModel)

        case .sessionLength:
            OnboardingSessionLengthView()
                .environmentObject(viewModel)

        case .experienceLevel:
            OnboardingExperienceView()
                .environmentObject(viewModel)

        case .fitnessBenchmark:
            OnboardingBenchmarkView(viewModel: viewModel)

        case .injuries:
            OnboardingInjuriesView(viewModel: viewModel)

        case .dietaryNeeds:
            OnboardingDietNeedsView(viewModel: viewModel)

        case .cookingSkill:
            OnboardingCookingSkillView(viewModel: viewModel)

        case .recentIntake:
            OnboardingRecentIntakeView(viewModel: viewModel)

        case .foodAversions:
            OnboardingFoodAversionsView(viewModel: viewModel)

        case .coachStyle:
            OnboardingCoachStyleView(viewModel: viewModel)

        case .connectHealth:
            OnboardingConnectHealthView(viewModel: viewModel)

        case .aiAnalysis:
            ProgramBuildingView()
                .environmentObject(viewModel)

        case .planSummary:
            OnboardingPlanSummaryView(viewModel: viewModel)
        }
    }
}

#Preview {
    OnboardingFlowView()
}




