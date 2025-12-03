import Foundation
import Combine

final class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .welcome
    @Published var primaryGoal: PrimaryGoal? = nil
    @Published var goalTimeline: GoalTimeline? = nil
    @Published var weeklyFatLoss: Double = 0.8 {   // default recommended
        didSet {
            goalTimeline = mappedGoalTimeline
        }
    }

    // In the future we will store the user's answers here as properties.
    
    /// Maps weeklyFatLoss to GoalTimeline
    private var mappedGoalTimeline: GoalTimeline {
        if weeklyFatLoss < 0.55 {
            return .sustainable
        } else if weeklyFatLoss <= 1.0 {
            return .moderate
        } else {
            return .aggressive
        }
    }

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

extension OnboardingViewModel {
    enum GoalTimeline: String, CaseIterable {
        case aggressive
        case moderate
        case sustainable

        var title: String {
            switch self {
            case .aggressive: return "Aggressive (≈3 months)"
            case .moderate: return "Moderate (≈6 months)"
            case .sustainable: return "Sustainable (9+ months)"
            }
        }

        var subtitle: String {
            switch self {
            case .aggressive: return "Fast results with higher intensity and discipline."
            case .moderate: return "Balanced progress with room for life and recovery."
            case .sustainable: return "Slow, steady change that's easiest to maintain."
            }
        }

        var symbolName: String {
            switch self {
            case .aggressive: return "hare.fill"
            case .moderate: return "speedometer"
            case .sustainable: return "tortoise.fill"
            }
        }
    }
    
    static var preview: OnboardingViewModel {
        let vm = OnboardingViewModel()
        // Optionally set some sample answers here later
        return vm
    }
}

