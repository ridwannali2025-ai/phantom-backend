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
    
    @Published var currentStep: Int = 0
    @Published var answers = OnboardingAnswers()
    
    let stepsCount = 4
    
    init(container: AppContainer) {
        self.container = container
    }
    
    /// Select a fitness goal
    func selectGoal(_ goal: FitnessGoal) {
        answers.goal = goal
    }
    
    /// Select training days per week
    func selectTrainingDays(_ days: Int) {
        answers.trainingDaysPerWeek = days
    }
    
    /// Select training experience level
    func selectExperience(_ level: TrainingExperience) {
        answers.trainingExperience = level
    }
    
    /// Move to the previous step
    func goToPreviousStep() {
        previousStep()
    }
    
    /// Move to the next step
    func goToNextStep() {
        // For now, just increment currentStep by 1 with bounds checking
        if currentStep < stepsCount - 1 {
            currentStep += 1
        }
    }
    
    /// Move to the next step (legacy method for compatibility)
    func nextStep() {
        guard currentStep < stepsCount - 1 else { return }
        currentStep += 1
    }
    
    /// Move to the previous step
    func previousStep() {
        guard currentStep > 0 else { return }
        currentStep -= 1
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

