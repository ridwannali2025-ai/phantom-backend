//
//  OnboardingTrainingDaysView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingTrainingDaysView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @State private var selectedDays: Int? = nil

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title & subtitle with generous spacing
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How many days per week can you train?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("This helps us design a program that fits your schedule.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 32)
                    .padding(.horizontal, 24)

                    // Days selection pills
                    VStack(spacing: 12) {
                        daysPill(2)
                        daysPill(3)
                        daysPill(4)
                        daysPill(5)
                        daysPill(6)
                    }
                    .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Bottom-anchored Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: selectedDays != nil,
                action: {
                    guard let selectedDays else { return }
                    onboarding.answers.trainingDaysPerWeek = selectedDays
                    onboarding.goToNext()
                }
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Prefill days if user navigates back
            if let savedDays = onboarding.answers.trainingDaysPerWeek {
                selectedDays = savedDays
            }
        }
    }
    
    // MARK: - Days Pill
    
    private func daysPill(_ days: Int) -> some View {
        let isSelected = selectedDays == days
        
        return Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) {
                selectedDays = days
            }
        }) {
            HStack(spacing: 12) {
                Text("\(days)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text(days == 1 ? "day" : "days")
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
    OnboardingTrainingDaysView()
        .environmentObject(OnboardingViewModel.preview)
}




