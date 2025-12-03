import Foundation
import Combine

final class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .welcome

    // In the future we will store the user's answers here as properties.

    var canGoBack: Bool {
        currentStep != .welcome
    }

    var progress: Double {
        let current = Double(currentStep.stepIndex)
        let total = Double(OnboardingStep.totalSteps)
        return current / total
    }

    func goNext() {
        guard let index = OnboardingStep.allCases.firstIndex(of: currentStep),
              index + 1 < OnboardingStep.allCases.count else {
            return
        }
        currentStep = OnboardingStep.allCases[index + 1]
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

