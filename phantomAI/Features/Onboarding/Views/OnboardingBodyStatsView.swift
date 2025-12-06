//
//  OnboardingBodyStatsView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingBodyStatsView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @State private var feet: Int = 5
    @State private var inches: Int = 8
    @State private var usesMetric: Bool = false
    @State private var heightCm: Double = 173
    @State private var weightInput: Double = 75  // interpreted as kg if usesMetric, lbs otherwise

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(spacing: 32) {
                    // A. Title + subtitle (LEFT aligned)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Height & weight")
                            .font(.system(size: 32, weight: .bold))
                            .multilineTextAlignment(.leading)

                        Text("This will be used to calibrate your custom plan.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 32)
                    .padding(.horizontal, 24)

                    // B. Imperial / Metric toggle row (CENTERED)
                    HStack(spacing: 16) {
                        Text("Imperial")
                            .font(.system(size: 20, weight: usesMetric ? .regular : .semibold))
                            .foregroundColor(usesMetric ? Color.secondary.opacity(0.4) : .primary)

                        Toggle("", isOn: Binding(
                            get: { usesMetric },
                            set: { newValue in
                                let oldValue = usesMetric
                                usesMetric = newValue
                                
                                // Convert values when switching
                                if !oldValue && newValue {
                                    // Converting from Imperial to Metric
                                    // Height: feet/inches to cm
                                    let totalInches = feet * 12 + inches
                                    heightCm = Double(totalInches) * 2.54
                                    
                                    // Weight: lbs to kg
                                    weightInput = weightInput / 2.20462
                                } else if oldValue && !newValue {
                                    // Converting from Metric to Imperial
                                    // Height: cm to feet/inches
                                    let totalInches = Int(heightCm / 2.54)
                                    feet = totalInches / 12
                                    inches = totalInches % 12
                                    
                                    // Weight: kg to lbs
                                    weightInput = weightInput * 2.20462
                                }
                            }
                        ))
                            .labelsHidden()
                            .toggleStyle(SwitchToggleStyle(tint: Color.black))

                        Text("Metric")
                            .font(.system(size: 20, weight: usesMetric ? .semibold : .regular))
                            .foregroundColor(usesMetric ? .primary : Color.secondary.opacity(0.4))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 24)

                    // C. Height / Weight wheels in one horizontal panel
                    ZStack {
                        // soft white panel behind the pickers like the screenshot
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color.white.opacity(0.85))
                            .shadow(color: Color.black.opacity(0.05), radius: 18, x: 0, y: 10)

                        VStack(spacing: 16) {
                            HStack {
                                Text("Height")
                                    .font(.system(size: 18, weight: .semibold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Weight")
                                    .font(.system(size: 18, weight: .semibold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal, 24)

                            HStack(spacing: 32) {
                                // HEIGHT PICKERS
                                Group {
                                    if usesMetric {
                                        Picker("Height (cm)", selection: $heightCm) {
                                            ForEach(130...210, id: \.self) { value in
                                                Text("\(value) cm").tag(Double(value))
                                            }
                                        }
                                    } else {
                                        HStack(spacing: 0) {
                                            Picker("Feet", selection: $feet) {
                                                ForEach(4...7, id: \.self) { ft in
                                                    Text("\(ft) ft").tag(ft)
                                                }
                                            }

                                            Picker("Inches", selection: $inches) {
                                                ForEach(0...11, id: \.self) { inch in
                                                    Text("\(inch) in").tag(inch)
                                                }
                                            }
                                        }
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(maxWidth: .infinity)

                                // WEIGHT PICKER
                                Group {
                                    if usesMetric {
                                        Picker("Weight (kg)", selection: $weightInput) {
                                            ForEach(40...180, id: \.self) { value in
                                                Text("\(value) kg").tag(Double(value))
                                            }
                                        }
                                    } else {
                                        Picker("Weight (lb)", selection: $weightInput) {
                                            ForEach(90...400, id: \.self) { value in
                                                Text("\(value) lb").tag(Double(value))
                                            }
                                        }
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(maxWidth: .infinity)
                            }
                            .frame(height: 180)
                        }
                        .padding(.vertical, 24)
                    }
                    .padding(.horizontal, 8)

                    Spacer()
                        .frame(height: 40)
                }
            }

            // D. Continue button at bottom (unchanged behavior)
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: isValidBodyStats,
                action: {
                    // keep the existing conversion + validation logic
                    let computedHeightCm: Double
                    if usesMetric {
                        computedHeightCm = heightCm
                    } else {
                        let totalInches = Double(feet * 12 + inches)
                        computedHeightCm = totalInches * 2.54
                    }

                    let computedWeightKg: Double
                    if usesMetric {
                        computedWeightKg = weightInput
                    } else {
                        computedWeightKg = weightInput / 2.20462
                    }

                    guard computedHeightCm > 100, computedHeightCm < 250,
                          computedWeightKg > 30, computedWeightKg < 250 else {
                        return
                    }

                    onboarding.answers.heightCm = computedHeightCm
                    onboarding.answers.weightKg = computedWeightKg
                    onboarding.goToNext()
                }
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Prefill from answers, preserving existing logic:
            if let savedHeight = onboarding.answers.heightCm {
                heightCm = savedHeight
                let totalInches = savedHeight / 2.54
                let ft = Int(totalInches / 12)
                let inch = Int(totalInches.truncatingRemainder(dividingBy: 12))
                feet = ft
                inches = inch
            }

            if let savedWeightKg = onboarding.answers.weightKg {
                weightInput = usesMetric ? savedWeightKg : savedWeightKg * 2.20462
            }
        }
    }
    
    // MARK: - Validation
    
    private var isValidBodyStats: Bool {
        let h = usesMetric ? heightCm : Double(feet * 12 + inches) * 2.54
        let w = usesMetric ? weightInput : weightInput / 2.20462
        return h > 100 && h < 250 && w > 30 && w < 250
    }
}

#Preview {
    OnboardingBodyStatsView()
        .environmentObject(OnboardingViewModel.preview)
}
