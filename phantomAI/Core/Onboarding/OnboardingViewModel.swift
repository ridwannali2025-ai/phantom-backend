import Foundation
import Combine

final class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .welcome
    @Published var answers = OnboardingAnswers()

    var canGoBack: Bool {
        currentStep != .welcome
    }

    var progress: Double {
        let current = Double(currentStep.stepIndex)
        let total = Double(OnboardingStep.totalSteps)
        return current / total
    }

    func goToNext() {
        guard let index = OnboardingStep.allCases.firstIndex(of: currentStep),
              index + 1 < OnboardingStep.allCases.count else {
            return
        }
        currentStep = OnboardingStep.allCases[index + 1]
    }
    
    // Legacy alias for backward compatibility
    func goNext() {
        goToNext()
    }

    func goBack() {
        guard let index = OnboardingStep.allCases.firstIndex(of: currentStep),
              index > 0 else {
            return
        }
        currentStep = OnboardingStep.allCases[index - 1]
    }

    func goToFirstStep() {
        currentStep = .welcome
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

