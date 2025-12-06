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
    case coachHistory       // 14 - "Have you ever worked with a coach before?"
    case coachResults       // 15 - "Phantom helps you get long-term results"
    case fitnessBenchmark   // 16
    case injuries           // 17

    case dietaryNeeds       // 16
    case cookingSkill       // 17
    case recentIntake       // 18
    case foodAversions      // 19
    case coachStyle         // 20
    case trust              // 21
    case connectHealth      // 22
    case planTeaser         // 23
    case aiAnalysis         // 24
    case planSummary        // 25
    case signUp             // 26 - "Save your progress" sign-up screen
    case paywall            // 27 - Premium paywall screen

    var id: Int { rawValue }

    /// 1-based index for progress calculations
    var stepIndex: Int { rawValue + 1 }

    static let totalSteps: Int = OnboardingStep.allCases.count
    
    /// Active onboarding steps (excludes placeholder/inactive steps)
    /// Order matches the exact onboarding flow sequence
    static var activeSteps: [OnboardingStep] {
        [
            // 1) Goal selection
            .primaryGoal,
            // 2) Goal timeline
            .goalTimeline,
            // 3) Height & weight
            .bodyStats,
            // 4) Age (date of birth)
            .age,
            // 5) Sex
            .sex,
            // 6) Activity level
            .activityLevel,
            // 7) Training experience
            .experienceLevel,
            // 8) Weekly schedule / days per week
            .trainingDays,
            // 9) Injuries / restrictions
            .injuries,
            // 10) What's holding you back?
            .pastBlockers,
            // 11) Nutrition questions
            .dietaryNeeds,
            .foodAversions,
            // 12) "Thank you for trusting us" privacy screen
            .trust,
            // 13) Apple Health connect screen
            .connectHealth,
            // 14) "All done / generate my plan" screen
            .planTeaser,
            // 15) Program building / loading screen
            .aiAnalysis,
            // 16) Custom plan summary screen
            .planSummary,
            // 17) Save your progress (Apple / Google sign-in) screen
            .signUp,
            // 18) Paywall screen
            .paywall
        ]
    }
    
    /// Returns the next active step after the current step, or nil if at the end
    func nextActiveStep() -> OnboardingStep? {
        guard let currentIndex = OnboardingStep.activeSteps.firstIndex(of: self),
              currentIndex + 1 < OnboardingStep.activeSteps.count else {
            return nil
        }
        return OnboardingStep.activeSteps[currentIndex + 1]
    }
    
    /// Returns the previous active step before the current step, or nil if at the beginning
    func previousActiveStep() -> OnboardingStep? {
        guard let currentIndex = OnboardingStep.activeSteps.firstIndex(of: self),
              currentIndex > 0 else {
            return nil
        }
        return OnboardingStep.activeSteps[currentIndex - 1]
    }
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
             .sessionLength, .experienceLevel, .coachHistory, .coachResults, .fitnessBenchmark, .injuries:
            return .workoutEngine

        case .dietaryNeeds, .cookingSkill, .recentIntake, .foodAversions,
             .coachStyle, .trust, .connectHealth, .planTeaser, .aiAnalysis, .planSummary, .signUp, .paywall:
            return .nutritionPaywall
        }
    }
}




