//
//  OnboardingDietNeedsView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingDietNeedsView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @State private var selectedRestrictions: Set<DietaryRestriction> = []

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title & subtitle with generous spacing
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Any dietary restrictions?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("We'll tailor your nutrition guidance around this.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 32)
                    .padding(.horizontal, 24)

                    // Dietary restriction selection cards (multi-select)
                    VStack(spacing: 12) {
                        ForEach(DietaryRestriction.allCases) { restriction in
                            dietaryRestrictionCard(for: restriction)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Bottom-anchored Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: true, // Always enabled - empty means .none
                action: {
                    onboarding.answers.dietaryRestrictions = finalRestrictions
                    onboarding.goToNext()
                }
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Prefill from existing answers if user navigates back
            if let saved = onboarding.answers.dietaryRestrictions {
                selectedRestrictions = Set(saved)
            }
        }
    }
    
    // MARK: - Final Restrictions
    
    private var finalRestrictions: [DietaryRestriction] {
        let array = Array(selectedRestrictions)
        if array.isEmpty {
            return [.none]
        }
        return array
    }
    
    // MARK: - Dietary Restriction Card
    
    private func dietaryRestrictionCard(for restriction: DietaryRestriction) -> some View {
        let isSelected = selectedRestrictions.contains(restriction)
        
        return OnboardingSelectableCard(
            isSelected: isSelected,
            content: {
                HStack(spacing: 12) {
                    Text(restriction.rawValue)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .primary)
                    
                    Spacer()
                    
                    // Checkmark when selected
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                .frame(height: 60)
            },
            onTap: {
                toggleSelection(for: restriction)
            }
        )
    }
    
    // MARK: - Selection Logic
    
    private func toggleSelection(for restriction: DietaryRestriction) {
        withAnimation(.easeInOut(duration: 0.15)) {
            if restriction == .none {
                // If tapping "No restrictions", toggle it on/off
                if selectedRestrictions.contains(.none) {
                    selectedRestrictions.removeAll()
                } else {
                    selectedRestrictions = [.none]
                }
            } else {
                // For any specific restriction:
                if selectedRestrictions.contains(restriction) {
                    selectedRestrictions.remove(restriction)
                } else {
                    selectedRestrictions.insert(restriction)
                    // If a specific restriction is selected, remove .none
                    selectedRestrictions.remove(.none)
                }
            }
        }
    }
}

#Preview {
    OnboardingDietNeedsView()
        .environmentObject(OnboardingViewModel.preview)
}




