import Foundation

enum OnboardingStep: Int, CaseIterable, Identifiable {
    case welcome            // 1
    case primaryGoal        // 2
    case goalTimeline       // 3

    case bodyStats          // 4
    case weight             // 5
    case age                // 6
    case sex                // 7
    case activityLevel      // 8
    case workoutTime        // 6
    case sleepHours         // 7
    case pastBlockers       // 8

    case equipmentAccess    // 9
    case trainingDays       // 10
    case splitPreference    // 11
    case sessionLength      // 12
    case experienceLevel    // 13
    case fitnessBenchmark   // 14
    case injuries           // 15

    case dietaryNeeds       // 16
    case cookingSkill       // 17
    case recentIntake       // 18
    case foodAversions      // 19
    case coachStyle         // 20

    case connectHealth      // 21
    case aiAnalysis         // 22
    case planSummary        // 23

    var id: Int { rawValue }

    /// 1-based index for progress calculations
    var stepIndex: Int { rawValue + 1 }

    static let totalSteps: Int = OnboardingStep.allCases.count
}

enum OnboardingPhase: Int, CaseIterable {
    case trustBuilder      // steps 1–3
    case foundation        // steps 4–8
    case workoutEngine     // steps 9–15
    case nutritionPaywall  // steps 16–23
}

extension OnboardingStep {
    var phase: OnboardingPhase {
        switch self {
        case .welcome, .primaryGoal, .goalTimeline:
            return .trustBuilder

        case .bodyStats, .weight, .age, .sex, .activityLevel, .workoutTime, .sleepHours, .pastBlockers:
            return .foundation

        case .equipmentAccess, .trainingDays, .splitPreference,
             .sessionLength, .experienceLevel, .fitnessBenchmark, .injuries:
            return .workoutEngine

        case .dietaryNeeds, .cookingSkill, .recentIntake, .foodAversions,
             .coachStyle, .connectHealth, .aiAnalysis, .planSummary:
            return .nutritionPaywall
        }
    }
}




