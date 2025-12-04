//
//  OnboardingSessionLengthView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingSessionLengthView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @State private var selectedMinutes: Int? = nil

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title & subtitle with generous spacing
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How long are your workout sessions?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("Choose the typical length of time you can dedicate to each workout.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 32)
                    .padding(.horizontal, 24)

                    // Session length selection pills
                    VStack(spacing: 12) {
                        minutesPill(30)
                        minutesPill(45)
                        minutesPill(60)
                        minutesPill(75)
                    }
                    .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Bottom-anchored Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: selectedMinutes != nil,
                action: {
                    guard let selectedMinutes else { return }
                    onboarding.answers.sessionLengthMinutes = selectedMinutes
                    onboarding.goToNext()
                }
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Prefill minutes if user navigates back
            if let savedMinutes = onboarding.answers.sessionLengthMinutes {
                selectedMinutes = savedMinutes
            }
        }
    }
    
    // MARK: - Minutes Pill
    
    private func minutesPill(_ minutes: Int) -> some View {
        let isSelected = selectedMinutes == minutes
        
        return Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) {
                selectedMinutes = minutes
            }
        }) {
            HStack(spacing: 12) {
                Text("\(minutes)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text("minutes")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(isSelected ? .white.opacity(0.9) : .secondary)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isSelected ? Color(hex: "A06AFE") : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(isSelected ? Color.clear : Color(hex: "E5E5EA"), lineWidth: 1)
                    )
            )
            .shadow(
                color: isSelected ? Color(hex: "A06AFE").opacity(0.25) : Color.black.opacity(0.05),
                radius: isSelected ? 24 : 8,
                x: 0,
                y: isSelected ? 8 : 2
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    OnboardingSessionLengthView()
        .environmentObject(OnboardingViewModel.preview)
}
