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
        // NOTE: Placeholder – not part of active flow yet
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
            OnboardingWorkoutTimeView()
                .environmentObject(viewModel)

        case .sleepHours:
            OnboardingSleepView()
                .environmentObject(viewModel)

        // NOTE: Placeholder – not part of active flow yet
        case .pastBlockers:
            OnboardingPastBlockersView(viewModel: viewModel)

        case .equipmentAccess:
            OnboardingEquipmentView()
                .environmentObject(viewModel)

        case .trainingDays:
            OnboardingTrainingDaysView()
                .environmentObject(viewModel)

        case .splitPreference:
            OnboardingSplitPreferenceView()
                .environmentObject(viewModel)

        case .sessionLength:
            OnboardingSessionLengthView()
                .environmentObject(viewModel)

        case .experienceLevel:
            OnboardingExperienceView()
                .environmentObject(viewModel)

        // NOTE: Placeholder – not part of active flow yet
        case .fitnessBenchmark:
            OnboardingBenchmarkView(viewModel: viewModel)

        case .injuries:
            OnboardingInjuriesView()
                .environmentObject(viewModel)

        case .dietaryNeeds:
            OnboardingDietNeedsView()
                .environmentObject(viewModel)

        // NOTE: Placeholder screen — not part of active onboarding flow
        case .cookingSkill:
            OnboardingCookingSkillView(viewModel: viewModel)

        // NOTE: Placeholder screen — not part of active onboarding flow
        case .recentIntake:
            OnboardingRecentIntakeView(viewModel: viewModel)

        case .foodAversions:
            OnboardingFoodAversionsView()
                .environmentObject(viewModel)

        case .trust:
            OnboardingTrustView()
                .environmentObject(viewModel)

        case .connectHealth:
            OnboardingHealthConnectView()
                .environmentObject(viewModel)

        // NOTE: Removed from active flow – not part of active onboarding sequence
        case .coachStyle:
            OnboardingCoachStyleView()
                .environmentObject(viewModel)

        case .planTeaser:
            PlanTeaserView()
                .environmentObject(viewModel)

        case .aiAnalysis:
            ProgramBuildingView()
                .environmentObject(viewModel)

        case .planSummary:
            OnboardingPlanSummaryView()
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    OnboardingFlowView()
}




