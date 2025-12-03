//
//  OnboardingHeaderView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Header component for onboarding screens with back button and progress dots
struct OnboardingHeaderView: View {
    let currentStep: Int
    let totalSteps: Int
    let onBack: (() -> Void)?
    
    init(currentStep: Int, totalSteps: Int = 4, onBack: (() -> Void)? = nil) {
        self.currentStep = currentStep
        self.totalSteps = totalSteps
        self.onBack = onBack
    }
    
    var body: some View {
        HStack {
            // Back button
            if let onBack = onBack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(hex: "A259FF"))
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 44, height: 44)
                }
            } else {
                Spacer()
                    .frame(width: 44, height: 44)
            }
            
            Spacer()
            
            // Progress dots
            HStack(spacing: 8) {
                ForEach(0..<totalSteps, id: \.self) { index in
                    Circle()
                        .fill(index <= currentStep ? Color(hex: "A259FF") : Color(hex: "E5E5EA"))
                        .frame(width: 8, height: 8)
                }
            }
            
            Spacer()
            
            // Balance spacer
            Spacer()
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
}

#Preview {
    VStack(spacing: 20) {
        OnboardingHeaderView(currentStep: 0, totalSteps: 4, onBack: nil)
        OnboardingHeaderView(currentStep: 1, totalSteps: 4, onBack: {})
        OnboardingHeaderView(currentStep: 2, totalSteps: 4, onBack: {})
    }
    .padding()
}

