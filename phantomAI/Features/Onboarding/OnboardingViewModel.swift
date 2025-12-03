//
//  OnboardingViewModel.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation
import Combine

/// View model for onboarding flow
/// Manages onboarding state and completion
@MainActor
final class OnboardingViewModel: ObservableObject {
    let container: AppContainer
    
    @Published var currentStep: OnboardingStep = .primaryGoal
    @Published var answers = OnboardingAnswers()
    
    init(container: AppContainer) {
        self.container = container
    }
    
    /// Select a fitness goal (legacy method - maps to primaryGoal)
    func selectGoal(_ goal: FitnessGoal) {
        // Map legacy FitnessGoal to PrimaryGoal
        if let primaryGoal = PrimaryGoal(rawValue: goal.rawValue) {
            answers.primaryGoal = primaryGoal
        }
        answers.goal = goal // Keep for backward compatibility
    }
    
    /// Select training days per week
    func selectTrainingDays(_ days: Int) {
        answers.trainingDaysPerWeek = days
    }
    
    /// Select training experience level
    func selectExperience(_ level: TrainingExperience) {
        answers.trainingExperience = level
    }
    
    /// Move to the next step
    func goToNextStep() {
        if let next = currentStep.next() {
            currentStep = next
        }
    }
    
    /// Move to the previous step
    func goToPreviousStep() {
        if let previous = currentStep.previous() {
            currentStep = previous
        }
    }
    
    /// Move to the next step (legacy method for compatibility)
    func nextStep() {
        goToNextStep()
    }
    
    /// Move to the previous step (legacy method for compatibility)
    func previousStep() {
        goToPreviousStep()
    }
    
    /// Complete onboarding and mark as completed
    /// - Parameter onFinished: Callback to execute when onboarding is complete
    func completeOnboarding(onFinished: @escaping () -> Void) {
        // Mark onboarding as completed
        container.localStorageService.setOnboardingCompleted(true)
        
        // Track analytics event
        container.analyticsService.track(event: AnalyticsEvent(
            name: "onboarding_completed",
            parameters: [:]
        ))
        
        // Execute completion callback
        onFinished()
    }
}

