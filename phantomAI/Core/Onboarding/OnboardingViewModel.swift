import Foundation
import Combine

final class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .primaryGoal
    @Published var answers = OnboardingAnswers()
    @Published var generatedProgram: Program?
    @Published var generatedPlan: GeneratedPlan?
    
    /// Tracks whether generatedPlan came from AI/backend (true) or is a local teaser (false)
    private var didGeneratePlanFromAI: Bool = false

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
    
    func finishOnboarding() {
        // TODO: Set some flag like hasCompletedOnboarding = true
        // For now just call goToNext() so the app can transition out of onboarding.
        goToNext()
    }
    
    func completePaywall(selectedYearly: Bool) {
        // TODO: integrate with Superwall / StoreKit later.
        // For now, just end onboarding and go into the main app.
        finishOnboarding()
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
    
    /// Non-optional ProgramRequest computed property
    /// Uses force unwraps with defaults for required fields
    var programRequest: ProgramRequest {
        ProgramRequest(
            goal: answers.primaryGoal!,
            timelineMonths: {
                switch answers.goalTimeline! {
                case .aggressive: return 3
                case .moderate: return 6
                case .sustainable: return 12
                }
            }(),
            heightCm: answers.heightCm!,
            weightKg: answers.weightKg!,
            age: answers.age ?? 0,
            sex: answers.sex!,
            activityLevel: answers.activityLevel!,
            daysPerWeek: answers.trainingDaysPerWeek ?? 3,
            experience: answers.trainingExperience!,
            equipment: answers.equipment,
            hasInjuries: answers.hasInjuries ?? false,
            injuryDetails: answers.injuryDetails,
            dietaryRestrictions: answers.dietaryRestrictions,
            avoidFoods: answers.avoidFoods,
            pastBlockers: answers.pastBlockers,
            hasWorkedWithCoach: answers.hasWorkedWithCoach ?? false,
            hasUsedOtherApps: answers.hasUsedOtherApps ?? false,
            coachStyle: answers.coachStyle,
            workoutTime: answers.workoutTime,
            sleepHours: answers.sleepHours,
            sessionLengthMinutes: answers.sessionLengthMinutes,
            trainingSplit: answers.trainingSplit
        )
    }
    
    /// Returns true only if all required fields in `answers` are non-nil / valid
    var isOnboardingComplete: Bool {
        // Required fields for program generation (based on ProgramRequest requirements)
        guard answers.primaryGoal != nil,
              answers.goalTimeline != nil,
              answers.heightCm != nil,
              answers.weightKg != nil,
              answers.age != nil,
              answers.sex != nil,
              answers.activityLevel != nil,
              answers.trainingDaysPerWeek != nil,
              answers.trainingExperience != nil else {
            return false
        }
        
        // Validate ranges
        guard let heightCm = answers.heightCm,
              heightCm > 100 && heightCm < 250,
              let weightKg = answers.weightKg,
              weightKg > 30 && weightKg < 250,
              let age = answers.age,
              age >= 13 && age <= 80 else {
            return false
        }
        
        // Optional fields that should be set if user has injuries
        if answers.hasInjuries == true {
            // If hasInjuries is true, injuryDetails should be non-empty
            if let details = answers.injuryDetails,
               details.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
        }
        
        return true
    }
    
    /// Generates program from AI/backend if needed (only after paywall purchase)
    /// This is called silently in the background after successful subscription
    func generateProgramFromAIIfNeeded() async {
        // If we already have a plan from AI, do nothing
        guard !didGeneratePlanFromAI else {
            return
        }
        
        // Build request from answers
        let request = programRequest
        
        // Call AI service
        let engineService = ProgramEngineService()
        do {
            let aiPlan = try await engineService.generatePlan(from: request)
            
            // Update on main thread
            await MainActor.run {
                self.generatedPlan = aiPlan
                self.didGeneratePlanFromAI = true
            }
        } catch {
            // Silently fail - keep using teaser plan
            // No error shown to user, no crash
            print("AI program generation failed, keeping teaser plan: \(error.localizedDescription)")
        }
    }
}

