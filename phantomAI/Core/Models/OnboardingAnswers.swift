//
//  OnboardingAnswers.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation

/// Stores user answers from the onboarding flow
struct OnboardingAnswers: Codable {
    // Phase 1 – Goals & motivation
    var primaryGoal: PrimaryGoal?              // Q1
    var goalTimeline: GoalTimeline?            // aggressive / moderate / sustainable
    var commitmentScore: Int?                  // 1–10
    var pastBarriers: [PastBarrier] = []       // consistency, nutrition, injury, etc.
    
    // Phase 2 – Biometric & lifestyle
    var heightCm: Double?
    var weightKg: Double?
    var age: Int?
    var birthMonth: Int?      // 1-12
    var birthDay: Int?         // 1-31
    var birthYear: Int?        // Year of birth
    var sex: SexType?
    /// Date of birth (computed from birthMonth, birthDay, birthYear)
    var dateOfBirth: Date? {
        get {
            guard let year = birthYear, let month = birthMonth, let day = birthDay else { return nil }
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = day
            return Calendar.current.date(from: components)
        }
        set {
            if let date = newValue {
                let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
                birthYear = components.year
                birthMonth = components.month
                birthDay = components.day
            }
        }
    }
    var activityLevel: ActivityLevel?
    var sleepHours: Double?                    // 4–10 hours
    var workoutTime: WorkoutTime?              // morning, lunch, evening, flexible
    /// Biggest things that have held them back in the past
    var pastBlockers: [PastBlocker]? = nil
    
    // Phase 3 – Training profile
    var equipment: [EquipmentOption] = []      // full gym, dumbbells, bands, bodyweight, etc.
    var trainingDaysPerWeek: Int?              // already used by schedule screen
    var trainingExperience: TrainingExperience?// already used by experience screen
    var sessionLengthMinutes: Int?            // 30, 45, 60, 75 minutes
    var trainingSplit: TrainingSplit?         // preferred training split (optional hint)
    /// Has the user ever worked with a coach before? (Yes/No)
    var hasWorkedWithCoach: Bool?
    /// Alias for hasWorkedWithCoach (kept for API compatibility)
    var hasUsedCoachBefore: Bool? {
        get { hasWorkedWithCoach }
        set { hasWorkedWithCoach = newValue }
    }
    /// Has the user used other fitness apps before?
    var hasUsedOtherApps: Bool?
    var hasInjuries: Bool?
    var injuryDetails: String?
    /// Gym access (maps to equipment but kept for clarity)
    var gymAccess: Bool?                      // true if has full gym access
    /// Obstacles that have held them back (similar to pastBlockers but for training context)
    var obstacles: [PastBlocker] = []         // consistency, time, etc.
    
    // Phase 4 – Nutrition profile
    var dietaryRestrictions: [DietaryRestriction]? // vegan, dairy-free, etc.
    var avoidFoods: String?                    // free text for foods they hate
    var cookingComfort: CookingComfort?
    /// Dietary needs (alias for dietaryRestrictions, kept for API compatibility)
    var dietaryNeeds: [DietaryRestriction]? {
        get { dietaryRestrictions }
        set { dietaryRestrictions = newValue }
    }
    /// Food aversions (alias for avoidFoods, kept for API compatibility)
    var foodAversions: String? {
        get { avoidFoods }
        set { avoidFoods = newValue }
    }
    
    // Phase 5 – Coach persona
    var coachStyle: CoachStyle?                // supportive / challenging
    
    // Legacy field for backward compatibility (maps to primaryGoal)
    var goal: FitnessGoal? {
        get {
            // Map primaryGoal to legacy goal if needed
            guard let primary = primaryGoal else { return nil }
            return FitnessGoal(rawValue: primary.rawValue)
        }
        set {
            // Map legacy goal to primaryGoal if needed
            if let legacyGoal = newValue {
                primaryGoal = PrimaryGoal(rawValue: legacyGoal.rawValue)
            }
        }
    }
}

// MARK: - Phase 1 Enums

/// Primary fitness goal
enum PrimaryGoal: String, CaseIterable, Identifiable, Codable {
    case buildMuscle = "Build muscle"
    case loseFat = "Lose fat"
    case getStronger = "Get stronger"
    case improveEndurance = "Improve endurance"
    case generalFitness = "General fitness"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .buildMuscle: return "Build Muscle"
        case .loseFat: return "Lose Fat"
        case .getStronger: return "Get Stronger"
        case .improveEndurance: return "Improve Endurance"
        case .generalFitness: return "General Fitness"
        }
    }
    
    /// SF Symbols icon for each goal (visual pill selector)
    var symbolName: String {
        switch self {
        case .buildMuscle: return "dumbbell"
        case .loseFat: return "flame.fill"
        case .getStronger: return "bolt.fill"
        case .improveEndurance: return "figure.run"
        case .generalFitness: return "heart.fill"
        }
    }
}

/// Goal timeline preference
enum GoalTimeline: String, CaseIterable, Identifiable, Codable {
    case aggressive = "Aggressive"
    case moderate = "Moderate"
    case sustainable = "Sustainable"
    
    var id: String { rawValue }
}

/// Past barriers to fitness success
enum PastBarrier: String, CaseIterable, Identifiable, Codable {
    case consistency = "Consistency"
    case nutrition = "Nutrition"
    case injury = "Injury"
    case motivation = "Motivation"
    case time = "Time"
    case knowledge = "Knowledge"
    
    var id: String { rawValue }
}

/// Past blockers that have held users back from reaching their goals
enum PastBlocker: String, CaseIterable, Identifiable, Codable {
    case consistency = "Lack of consistency"
    case unhealthyEating = "Unhealthy eating habits"
    case lackOfSupport = "Lack of support"
    case busySchedule = "Busy schedule"
    case gymAnxiety = "Intimidation / Gym Anxiety"
    case lackOfKnowledge = "Lack of knowledge"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .consistency:
            return "Hard to stay on track for more than a few weeks."
        case .unhealthyEating:
            return "Snacking, takeout, or late-night eating gets in the way."
        case .lackOfSupport:
            return "No one around you keeps you accountable."
        case .busySchedule:
            return "Work, school, or life makes it hard to find time."
        case .gymAnxiety:
            return "The gym feels overwhelming or uncomfortable."
        case .lackOfKnowledge:
            return "Not sure what exercises to do or how to train effectively."
        }
    }
}

// MARK: - Phase 2 Enums

/// Sex type
enum SexType: String, Codable {
    case other
    case male
    case female
    
    var title: String {
        switch self {
        case .other: return "Other"
        case .male: return "Male"
        case .female: return "Female"
        }
    }
}

/// Biological sex (legacy - use SexType instead)
enum BiologicalSex: String, CaseIterable, Identifiable, Codable {
    case male = "Male"
    case female = "Female"
    case other = "Other"
    case preferNotToSay = "Prefer not to say"
    
    var id: String { rawValue }
}

/// Activity level
enum ActivityLevel: String, CaseIterable, Identifiable, Codable {
    case mostlySitting = "Mostly sitting"
    case sometimesOnFeet = "On your feet sometimes"
    case oftenOnFeet = "On your feet a lot"
    case veryActive = "Very active most days"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .mostlySitting: return "Mostly sitting"
        case .sometimesOnFeet: return "On your feet sometimes"
        case .oftenOnFeet: return "On your feet a lot"
        case .veryActive: return "Very active most days"
        }
    }
    
    var description: String {
        switch self {
        case .mostlySitting: return "Desk job, lots of sitting."
        case .sometimesOnFeet: return "Mix of sitting and light movement."
        case .oftenOnFeet: return "On the move for most of the day."
        case .veryActive: return "Physically demanding work or very active lifestyle."
        }
    }
    
    var symbolName: String {
        switch self {
        case .mostlySitting: return "laptopcomputer"
        case .sometimesOnFeet: return "figure.walk"
        case .oftenOnFeet: return "figure.run"
        case .veryActive: return "figure.strengthtraining.traditional"
        }
    }
}

/// Preferred workout time
enum WorkoutTime: String, CaseIterable, Identifiable, Codable {
    case morning = "Morning"
    case lunch = "Lunch"
    case evening = "Evening"
    case flexible = "Flexible"
    
    var id: String { rawValue }
}

// MARK: - Phase 3 Enums

/// Equipment options
enum EquipmentOption: String, CaseIterable, Identifiable, Codable {
    case fullGym = "Full gym"
    case dumbbells = "Dumbbells"
    case resistanceBands = "Resistance bands"
    case bodyweight = "Bodyweight only"
    case kettlebells = "Kettlebells"
    case barbell = "Barbell"
    case machines = "Machines"
    
    var id: String { rawValue }
}

/// Training experience levels
enum TrainingExperience: String, CaseIterable, Identifiable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    
    var id: String { rawValue }
}

/// Training split preference
enum TrainingSplit: String, CaseIterable, Identifiable, Codable {
    case fullBody = "Full body"
    case upperLower = "Upper / Lower"
    case pushPullLegs = "Push / Pull / Legs"
    case upperLowerPushPullLegs = "UL + PPL hybrid"
    case custom = "No preference / Let AI decide"
    
    var id: String { rawValue }
}

// MARK: - Phase 4 Enums

/// Dietary restrictions
enum DietaryRestriction: String, CaseIterable, Identifiable, Codable {
    case none = "No restrictions"
    case vegan = "Vegan"
    case vegetarian = "Vegetarian"
    case dairyFree = "Dairy-free"
    case glutenFree = "Gluten-free"
    case nutFree = "Nut-free"
    case pescatarian = "Pescatarian"
    case keto = "Keto"
    case paleo = "Paleo"
    case halal = "Halal"
    case kosher = "Kosher"
    
    var id: String { rawValue }
}

/// Cooking comfort level
enum CookingComfort: String, CaseIterable, Identifiable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case preferPrepared = "Prefer prepared meals"
    
    var id: String { rawValue }
}

// MARK: - Phase 5 Enums

/// Coach style preference
enum CoachStyle: String, CaseIterable, Identifiable, Codable {
    case direct = "Direct & No-Nonsense"
    case motivational = "Motivational & Energetic"
    case supportive = "Supportive & Friendly"
    case minimal = "Minimal / Quiet"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .direct:
            return "Straight to the point with clear instructions."
        case .motivational:
            return "Encouraging, energetic, and hype-driven."
        case .supportive:
            return "Friendly, positive, and partnership-focused."
        case .minimal:
            return "Just the essentials. No extra messages."
        }
    }
}

// MARK: - Legacy Enums (for backward compatibility)

/// Fitness goal options for onboarding (legacy - use PrimaryGoal instead)
enum FitnessGoal: String, CaseIterable, Codable, Identifiable {
    case buildMuscle = "Build muscle"
    case loseFat = "Lose fat"
    case getStronger = "Get stronger"
    case improveEndurance = "Improve endurance"
    case generalFitness = "General fitness"
    
    var id: String { rawValue }
}
