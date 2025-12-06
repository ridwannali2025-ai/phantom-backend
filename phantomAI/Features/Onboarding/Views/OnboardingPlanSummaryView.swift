//
//  OnboardingPlanSummaryView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingPlanSummaryView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @Environment(\.openURL) private var openURL

    var body: some View {
        ZStack {
            // 1) Scrollable content
            ScrollView(showsIndicators: true) {
                VStack(spacing: 24) {
                    headerSection
                    topCardsSection
                    howToReachGoalsSection
                    sourcesSection
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
                .padding(.bottom, 140) // Extra bottom padding so last content isn't hidden behind button
            }
            
            // 2) Bottom CTA pinned above safe area
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    // Subtle gradient fade hint
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.0),
                            Color.white.opacity(0.95)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 20)
                    
                    PrimaryContinueButton(
                        title: "Let's get started!",
                        isEnabled: true
                    ) {
                        // Navigate to sign-up screen
                        onboarding.goToNext()
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    .background(Color.white.ignoresSafeArea(edges: .bottom))
                }
            }
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Debug: Print generated plan
            print("GENERATED PLAN:", onboarding.generatedPlan as Any)
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(Color(hex: "A06AFE"))
                .padding(.bottom, 4)
            
            Text("Your custom plan is ready")
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
            
            if let goalText = headerGoalSummary {
                Text(goalText)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var headerGoalSummary: String? {
        let answers = onboarding.answers
        guard let goal = answers.primaryGoal else { return nil }
        
        let months: Int
        if let goalTimeline = answers.goalTimeline {
            switch goalTimeline {
            case .aggressive:
                months = 3
            case .moderate:
                months = 6
            case .sustainable:
                months = 12
            }
        } else {
            months = 6 // Default
        }
        
        switch goal {
        case .loseFat:
            return "We've built a fat loss plan for the next \(months) months."
        case .buildMuscle:
            return "We've built a muscle-building plan for the next \(months) months."
        case .getStronger:
            return "We've built a strength plan for the next \(months) months."
        default:
            return "We've built a plan tailored to your goals."
        }
    }
    
    // MARK: - Top Cards Section
    
    private let cardMinHeight: CGFloat = 260
    
    private var topCardsSection: some View {
        HStack(alignment: .top, spacing: 16) {
            caloriesCard
                .frame(maxWidth: .infinity)
                .frame(minHeight: cardMinHeight)
            
            workoutSplitCard
                .frame(maxWidth: .infinity)
                .frame(minHeight: cardMinHeight)
        }
    }
    
    // MARK: - Calories & Macros Card
    
    private var caloriesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily fuel")
                .font(.system(size: 16, weight: .semibold))
            
            // "First week meal goal" caption
            Text(onboarding.generatedPlan?.trainingSplitTitle ?? "First week meal goal")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
            
            // Simple donut style using ZStack
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 10)
                
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(Color(hex: "A06AFE"), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 2) {
                    Text("\(macroTargets.calories)")
                        .font(.system(size: 22, weight: .bold))
                    Text("kcal / day")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 120, height: 120)
            
            // Locked macros section
            VStack(alignment: .leading, spacing: 4) {
                macroRow(label: "Protein", grams: macroTargets.protein)
                macroRow(label: "Carbs", grams: macroTargets.carbs)
                macroRow(label: "Fats", grams: macroTargets.fats)
            }
            .font(.system(size: 13, weight: .medium))
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
        )
    }
    
    private func macroRow(label: String, grams: Int) -> some View {
        HStack(spacing: 8) {
            Text(label)
            Spacer()
            Text("\(grams) g")
                .redacted(reason: .placeholder)
                .opacity(0.5)
            Image(systemName: "lock.fill")
                .font(.system(size: 10))
                .foregroundColor(Color(hex: "A06AFE"))
        }
    }
    
    // MARK: - Training Schedule Card
    
    private var workoutSplitCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Training schedule")
                .font(.system(size: 16, weight: .semibold))
            
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: "A06AFE").opacity(0.1),
                            Color.blue.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    VStack(spacing: 12) {
                        // Large lock icon
                        Image(systemName: "lock.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(Color(hex: "A06AFE"))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 4)
                        
                        // Blurred placeholder lines
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(0..<3) { _ in
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.12))
                                    .frame(height: 10)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Footer text
                        Text(onboarding.generatedPlan?.trainingSplitSubtitle ?? "Full schedule unlocked after you start your first session.")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(16)
                )
                .frame(maxHeight: .infinity)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
        )
    }
    
    // MARK: - Macro Targets Helper
    
    private struct MacroTargets {
        let calories: Int
        let protein: Int // grams
        let carbs: Int   // grams
        let fats: Int    // grams
    }
    
    private var macroTargets: MacroTargets {
        // Use generatedPlan if available, otherwise fallback to calculation
        if let plan = onboarding.generatedPlan {
            return MacroTargets(
                calories: plan.caloriesPerDay,
                protein: plan.proteinGrams,
                carbs: plan.carbsGrams,
                fats: plan.fatsGrams
            )
        }
        
        // Fallback: Reuse calculation logic from PlanTeaserMetrics
        guard let metrics = PlanTeaserMetrics(answers: onboarding.answers) else {
            // Final fallback values if calculation fails
            return MacroTargets(calories: 2000, protein: 150, carbs: 200, fats: 65)
        }
        
        return MacroTargets(
            calories: metrics.targetCalories,
            protein: metrics.proteinGrams,
            carbs: metrics.carbGrams,
            fats: metrics.fatGrams
        )
    }
    
    // MARK: - Workout Split Summary
    
    private var workoutSplitSummary: String {
        // Best effort: look at program.workouts count & names
        if let program = onboarding.generatedProgram {
            let uniqueWorkoutNames = Set(program.workouts.map { $0.name })
            let workoutCount = uniqueWorkoutNames.count
            
            // Check workout names for common patterns
            let workoutNames = Array(uniqueWorkoutNames)
            
            if workoutCount == 2 {
                // Check if it's Upper/Lower
                let hasUpper = workoutNames.contains { $0.localizedCaseInsensitiveContains("upper") }
                let hasLower = workoutNames.contains { $0.localizedCaseInsensitiveContains("lower") }
                if hasUpper && hasLower {
                    return "Upper / Lower split"
                }
                return "Full body x2 / week"
            } else if workoutCount == 3 {
                // Check if it's Push/Pull/Legs
                let hasPush = workoutNames.contains { $0.localizedCaseInsensitiveContains("push") }
                let hasPull = workoutNames.contains { $0.localizedCaseInsensitiveContains("pull") }
                let hasLegs = workoutNames.contains { $0.localizedCaseInsensitiveContains("leg") }
                if hasPush && hasPull && hasLegs {
                    return "Push / Pull / Legs split"
                }
                return "Full body / rotation 3x week"
            } else if workoutCount == 4 {
                let hasUpper = workoutNames.contains { $0.localizedCaseInsensitiveContains("upper") }
                let hasLower = workoutNames.contains { $0.localizedCaseInsensitiveContains("lower") }
                if hasUpper && hasLower {
                    return "Upper / Lower split"
                }
                return "\(workoutCount)x per week program"
            } else if workoutCount >= 5 {
                let hasPush = workoutNames.contains { $0.localizedCaseInsensitiveContains("push") }
                let hasPull = workoutNames.contains { $0.localizedCaseInsensitiveContains("pull") }
                let hasLegs = workoutNames.contains { $0.localizedCaseInsensitiveContains("leg") }
                if hasPush && hasPull && hasLegs {
                    return "Push / Pull / Legs split"
                }
                return "\(workoutCount)x per week program"
            } else {
                return "\(workoutCount)x per week program"
            }
        }
        
        // Fallback: use training days from answers
        if let daysPerWeek = onboarding.answers.trainingDaysPerWeek {
            return "Personalized \(daysPerWeek)-day split based on your schedule"
        }
        
        return "Personalized 3–4 day split based on your schedule"
    }
    
    // MARK: - How to Reach Goals Section
    
    private var howToReachGoalsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How to reach your goals")
                .font(.system(size: 18, weight: .bold))
            
            VStack(alignment: .leading, spacing: 8) {
                bullet("Follow the daily workouts Phantom gives you.")
                bullet("Stay close to your calorie target most days.")
                bullet("Hit your protein goal and move at least \(stepsPerDayText) per day.")
                bullet("Check in with your AI coach whenever you feel stuck.")
            }
            .font(.system(size: 14))
            .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var stepsPerDayText: String {
        "7–8k steps"
    }
    
    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "A06AFE"))
                .padding(.top, 2)
            Text(text)
        }
    }
    
    // MARK: - Sources Section
    
    private var sourcesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Plan built from real science")
                .font(.system(size: 16, weight: .semibold))
            
            Text("Phantom uses guidelines from leading research, including:")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 6) {
                sourceLink("Basal metabolic rate – NIDDK", url: "https://www.niddk.nih.gov/")
                sourceLink("Calorie balance & weight change – NIH", url: "https://www.nih.gov/")
                sourceLink("Protein intake for lifters – ISSN", url: "https://jissn.biomedcentral.com/")
                sourceLink("Physical activity guidelines – CDC", url: "https://www.cdc.gov/")
            }
        }
        .font(.system(size: 13))
    }
    
    private func sourceLink(_ title: String, url: String) -> some View {
        Button {
            if let link = URL(string: url) {
                openURL(link)
            }
        } label: {
            Text("• \(title)")
                .underline()
                .multilineTextAlignment(.leading)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    OnboardingPlanSummaryView()
        .environmentObject(OnboardingViewModel.preview)
}
