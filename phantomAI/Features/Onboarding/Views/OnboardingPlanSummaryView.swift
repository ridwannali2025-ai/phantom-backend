//
//  OnboardingPlanSummaryView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingPlanSummaryView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel

    var body: some View {
        let dailyCalories = computedCalories()
        
        ZStack {
            // 1) Scrollable content
            ScrollView(showsIndicators: true) {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(Color(hex: "A06AFE"))
                            .padding(.bottom, 4)
                        
                        Text("Your custom plan is ready")
                            .font(.system(size: 28, weight: .bold))
                            .multilineTextAlignment(.center)
                        
                        Text("Here's your starting daily calorie target.")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 32)
                    
                    // Daily calories card
                    VStack(spacing: 16) {
                        Text("Daily calories")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text("\(dailyCalories)")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("kcal / day")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
                    )
                    
                    Spacer()
                        .frame(height: 40)
                }
                .padding(.horizontal, 24)
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
    }
    
    // MARK: - Calorie Calculation
    
    /// Computes daily calories from onboarding answers using Mifflin-St Jeor BMR formula
    private func computedCalories() -> Int {
        let answers = onboarding.answers
        
        // Validate required fields
        guard let sex = answers.sex,
              let age = answers.age,
              let heightCm = answers.heightCm,
              let weightKg = answers.weightKg,
              let activityLevel = answers.activityLevel else {
            print("OnboardingPlanSummaryView: Missing required data for calorie calculation, using fallback 2000 kcal")
            return 2000
        }
        
        // Calculate BMR using Mifflin-St Jeor
        let bmr: Double
        switch sex {
        case .male:
            bmr = 10 * weightKg + 6.25 * heightCm - 5 * Double(age) + 5
        case .female:
            bmr = 10 * weightKg + 6.25 * heightCm - 5 * Double(age) - 161
        case .other:
            // Treat as male for calculation
            bmr = 10 * weightKg + 6.25 * heightCm - 5 * Double(age) + 5
        }
        
        // Apply activity factor
        let activityFactor: Double
        switch activityLevel {
        case .mostlySitting:
            activityFactor = 1.2  // sedentary
        case .sometimesOnFeet:
            activityFactor = 1.375  // light
        case .oftenOnFeet:
            activityFactor = 1.55  // moderate
        case .veryActive:
            activityFactor = 1.725  // veryActive
        }
        
        // Calculate maintenance calories
        let maintenanceCalories = bmr * activityFactor
        
        // Round to nearest 10
        let rounded = (maintenanceCalories / 10).rounded() * 10
        
        return Int(rounded)
    }
}

#Preview {
    OnboardingPlanSummaryView()
        .environmentObject(OnboardingViewModel.preview)
}
