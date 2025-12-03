//
//  OnboardingHeaderView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Header component for onboarding screens with back button and progress indicator
struct OnboardingHeaderView: View {
    let currentStep: OnboardingStep
    let onBack: (() -> Void)?
    
    init(currentStep: OnboardingStep, onBack: (() -> Void)? = nil) {
        self.currentStep = currentStep
        self.onBack = onBack
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Back button
                if let onBack = onBack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(hex: "A06AFE"))
                            .font(.system(size: 17, weight: .medium))
                            .frame(width: 44, height: 44)
                    }
                } else {
                    Spacer()
                        .frame(width: 44, height: 44)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            
            // Progress bar
            progressBar(progress: progressValue)
                .padding(.horizontal, 24)
                .padding(.top, 12)
        }
    }
    
    /// Computes progress value (0.0 to 1.0) based on current step index
    private var progressValue: Double {
        let current = Double(currentStep.stepIndex)
        let total = Double(OnboardingStep.totalSteps)
        return current / total
    }
    
    /// Progress bar showing overall step progress
    private func progressBar(progress: Double) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background (gray)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(hex: "E5E5EA"))
                    .frame(height: 3)
                
                // Progress (purple)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(hex: "A06AFE"))
                    .frame(width: geometry.size.width * progress, height: 3)
            }
        }
        .frame(height: 3)
        .animation(.easeInOut(duration: 0.25), value: progress)
    }
}

#Preview {
    VStack(spacing: 20) {
        OnboardingHeaderView(currentStep: .welcome, onBack: nil)
        OnboardingHeaderView(currentStep: .primaryGoal, onBack: {})
        OnboardingHeaderView(currentStep: .bodyStats, onBack: {})
        OnboardingHeaderView(currentStep: .equipmentAccess, onBack: {})
        OnboardingHeaderView(currentStep: .dietaryNeeds, onBack: {})
    }
    .padding()
}

