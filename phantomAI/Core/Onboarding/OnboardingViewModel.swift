import Foundation
import Combine

final class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .primaryGoal
    @Published var answers = OnboardingAnswers()
    @Published var generatedProgram: Program?

    var canGoBack: Bool {
        guard let firstActiveStep = OnboardingStep.activeSteps.first else { return false }
        return currentStep != firstActiveStep
    }

    var progress: Double {
        guard let currentIndex = OnboardingStep.activeSteps.firstIndex(of: currentStep) else {
            return 0.0
        }
        let current = Double(currentIndex + 1)
        let total = Double(OnboardingStep.activeSteps.count)
        return current / total
    }

    func goToNext() {
        guard let nextStep = currentStep.nextActiveStep() else {
            return
        }
        currentStep = nextStep
    }
    
    // Legacy alias for backward compatibility
    func goNext() {
        goToNext()
    }

    func goBack() {
        guard let previousStep = currentStep.previousActiveStep() else {
            return
        }
        currentStep = previousStep
    }

    func goToFirstStep() {
        currentStep = OnboardingStep.activeSteps.first ?? .primaryGoal
    }
}

extension OnboardingViewModel {
    static var preview: OnboardingViewModel {
        let vm = OnboardingViewModel()
        // Optionally set some sample answers here later
        return vm
    }
    
    /// Creates a ProgramRequest from the current onboarding answers
    /// Returns nil if required fields are missing
    func makeProgramRequest() -> ProgramRequest? {
        ProgramRequest(from: answers)
    }
}

