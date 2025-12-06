//
//  PlanTeaserView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct PlanTeaserView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            contentArea
            ctaSection
        }
        .background(Color.white.ignoresSafeArea())
    }
    
    // MARK: - Main Content Area (handles metrics vs fallback)
    
    private var contentArea: some View {
        Group {
            if let metrics = PlanTeaserMetrics(answers: onboarding.answers) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        headerSection(metrics: metrics)
                        biologicalTruthSection(metrics: metrics)
                        efficiencySection(metrics: metrics)
                        strategySection(metrics: metrics)
                        safetySection(metrics: metrics)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 100)
                }
            } else {
                fallbackView
            }
        }
    }
    
    // MARK: - Fallback When Metrics Cannot Be Created
    
    private var fallbackView: some View {
        VStack(spacing: 12) {
            Text("Unable to generate analysis")
                .font(.title2.bold())
            
            Text("Please complete the previous steps, then try again.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
    }
    
    // MARK: - Header Section
    
    private func headerSection(metrics: PlanTeaserMetrics) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Analysis Complete.")
                .font(.title.bold())
            
            Text("We've built a strategy to help you reach your goals within your chosen timeline.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Biological Truth Section (Calories + Macros)
    
    private func biologicalTruthSection(metrics: PlanTeaserMetrics) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Daily Fuel Target")
                .font(.headline)
                .foregroundColor(.primary)
            
            // Big calorie number
            HStack(alignment: .center) {
                Spacer()
                VStack(spacing: 8) {
                    Text("\(metrics.targetCalories)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("kcal")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.vertical, 16)
            
            // Macro breakdown
            VStack(spacing: 12) {
                macroRow(label: "Protein", grams: metrics.proteinGrams, color: Color(hex: "A06AFE"))
                macroRow(label: "Carbs", grams: metrics.carbGrams, color: Color(hex: "7366FF"))
                macroRow(label: "Fats", grams: metrics.fatGrams, color: Color(hex: "FF6B6B"))
            }
            .padding(.top, 8)
            
            Text("Based on your current stats, this is the fuel mix we'll use to drive your progress.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    private func macroRow(label: String, grams: Int, color: Color) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text("\(grams) g")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
    }
    
    // MARK: - Efficiency Section
    
    private func efficiencySection(metrics: PlanTeaserMetrics) -> some View {
        let ageDiff = metrics.fitnessAge - metrics.actualAge
        
        return VStack(alignment: .leading, spacing: 16) {
            Text("Your Efficiency Score")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                HStack {
                    Text("Actual age:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(metrics.actualAge)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                HStack {
                    Text("Fitness age:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(metrics.fitnessAge)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(metrics.fitnessAge > metrics.actualAge ? .orange : Color(hex: "A06AFE"))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
            
            Group {
                if ageDiff > 0 {
                    Text("Your fitness age is currently \(ageDiff) years higher than your actual age. This plan is designed to reverse that trend.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                } else {
                    Text("Your fitness age is \(abs(ageDiff)) years younger than your actual age. This plan will help you maintain and improve that advantage.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
            }
        }
    }
    
    // MARK: - Strategy Section (Weekly Split Preview)
    
    private func strategySection(metrics: PlanTeaserMetrics) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Training Strategy")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Here's how we've structured your week.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                ForEach(Array(metrics.splitSummary.enumerated()), id: \.offset) { index, row in
                    HStack {
                        Text(row)
                            .font(.subheadline)
                            .foregroundColor(isLockedDay(index) ? .secondary.opacity(0.6) : .primary)
                        
                        Spacer()
                        
                        if isLockedDay(index) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                    )
                }
            }
            .padding(.top, 8)
        }
    }
    
    private func isLockedDay(_ index: Int) -> Bool {
        // Lock Thu, Fri, Sat (indices 3, 4, 5)
        return index >= 3 && index <= 5
    }
    
    // MARK: - Safety Section
    
    private func safetySection(metrics: PlanTeaserMetrics) -> some View {
        Group {
            if let injuryMessage = metrics.injuryMessage,
               let filteredCount = metrics.injuryFilteredCount {
                
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "shield.checkerboard")
                        .font(.title3)
                        .foregroundColor(Color(hex: "A06AFE"))
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Injury Safeguards Active")
                            .font(.headline)
                        
                        Text("We've automatically filtered out \(filteredCount) movements to protect your body during training.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(injuryMessage)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 4)
                )
                
            } else {
                EmptyView()
            }
        }
    }
    
    // MARK: - Bottom CTA
    
    private var ctaSection: some View {
        VStack(spacing: 8) {
            Button {
                // TODO: later replace with paywall trigger
                onboarding.goToNext()
            } label: {
                Text("Unlock My Custom Plan")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "A06AFE"))
                    .foregroundColor(.white)
                    .cornerRadius(16)
            }
            
            Text("Get instant access to your daily workout list and meal recipes.")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }
}

#Preview {
    PlanTeaserView()
        .environmentObject(OnboardingViewModel.preview)
}

