//
//  OnboardingAgeView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingAgeView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @State private var age: Int = 24

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title & subtitle with generous spacing
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How old are you?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("Your age helps us set realistic volume and recovery targets.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 32)
                    .padding(.horizontal, 24)

                    // Age picker card (centered)
                    HStack {
                        Spacer()
                        agePickerCard
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
                isEnabled: age >= 13 && age <= 80,
                action: {
                    onboarding.answers.age = age
                    onboarding.goToNext()
                }
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Prefill age if user navigates back
            if let savedAge = onboarding.answers.age {
                age = savedAge
            }
        }
    }
    
    // MARK: - Age Picker Card
    
    private var agePickerCard: some View {
        VStack(spacing: 0) {
            // Picker content
            HStack(spacing: 0) {
                Picker("Age", selection: $age) {
                    ForEach(13..<81) { ageValue in
                        Text("\(ageValue)").tag(ageValue)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                
                Text("years")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.secondary)
                    .padding(.leading, 12)
            }
            .frame(height: 200)
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "F7F7F7"))
        )
        .padding(.top, 24)
    }
}

#Preview {
    OnboardingAgeView()
        .environmentObject(OnboardingViewModel.preview)
}

