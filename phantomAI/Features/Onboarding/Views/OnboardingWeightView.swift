//
//  OnboardingWeightView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingWeightView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @State private var weightValue: Double = 160
    @State private var usesMetric: Bool = false   // false = lbs, true = kg

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title & subtitle with generous spacing
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What's your weight?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("Required to build accurate calorie + training targets.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 32)
                    .padding(.horizontal, 24)

                    // Weight picker card (centered)
                    HStack {
                        Spacer()
                        weightPickerCard
                            .frame(maxWidth: 400)
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Bottom-anchored Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: weightValue > 0,
                action: {
                    let weightKg = usesMetric ? weightValue : weightValue * 0.453592
                    onboarding.answers.weightKg = weightKg
                    onboarding.goToNext()
                }
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Prefill weight if user navigates back
            if let savedWeightKg = onboarding.answers.weightKg {
                // Default to metric (kg) for prefilled values
                weightValue = savedWeightKg
                usesMetric = true
            }
        }
    }
    
    // MARK: - Weight Picker Card
    
    private var weightPickerCard: some View {
        VStack(spacing: 0) {
            // Unit toggle at top-right
            HStack {
                Spacer()
                unitToggle
                    .padding(.top, 16)
                    .padding(.trailing, 16)
            }
            
            // Picker content
            if usesMetric {
                // Metric: Kilograms
                HStack(spacing: 0) {
                    Picker("Kilograms", selection: $weightValue) {
                        ForEach(Array(stride(from: 20.0, through: 227.0, by: 0.5)), id: \.self) { value in
                            Text(String(format: "%.1f", value)).tag(value)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)
                    
                    Text("kg")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.secondary)
                        .padding(.leading, 12)
                }
                .frame(height: 200)
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            } else {
                // Imperial: Pounds
                HStack(spacing: 0) {
                    Picker("Pounds", selection: $weightValue) {
                        ForEach(Array(stride(from: 50.0, through: 500.0, by: 1.0)), id: \.self) { value in
                            Text(String(format: "%.0f", value)).tag(value)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)
                    
                    Text("lbs")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.secondary)
                        .padding(.leading, 12)
                }
                .frame(height: 200)
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "F7F7F7"))
        )
        .padding(.top, 24)
    }
    
    // MARK: - Unit Toggle
    
    private var unitToggle: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                usesMetric.toggle()
                // Convert values when switching
                if usesMetric {
                    // Convert lbs to kg
                    weightValue = weightValue * 0.453592
                } else {
                    // Convert kg to lbs
                    weightValue = weightValue / 0.453592
                }
            }
        }) {
            HStack(spacing: 6) {
                Text(usesMetric ? "Metric" : "Imperial")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.primary)
                
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.white)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OnboardingWeightView()
        .environmentObject(OnboardingViewModel.preview)
}

