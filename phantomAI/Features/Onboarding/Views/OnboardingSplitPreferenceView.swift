//
//  OnboardingSplitPreferenceView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingSplitPreferenceView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @State private var selectedSplit: TrainingSplit? = nil

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title & subtitle with generous spacing
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Split Preference")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("Do you have a preferred training split?")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 32)
                    .padding(.horizontal, 24)

                    // Split selection cards
                    VStack(spacing: 12) {
                        ForEach(TrainingSplit.allCases) { split in
                            splitCard(for: split)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Bottom-anchored Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: selectedSplit != nil,
                action: {
                    guard let selectedSplit else { return }
                    onboarding.answers.trainingSplit = selectedSplit
                    onboarding.goToNext()
                }
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Prefill split if user navigates back
            if let savedSplit = onboarding.answers.trainingSplit {
                selectedSplit = savedSplit
            }
        }
    }
    
    // MARK: - Split Card
    
    private func splitCard(for split: TrainingSplit) -> some View {
        let isSelected = selectedSplit == split
        
        return OnboardingSelectableCard(
            isSelected: isSelected,
            content: {
                HStack(spacing: 12) {
                    // Split title
                    Text(split.rawValue)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .primary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .frame(height: 60)
            },
            onTap: {
                // Smooth animation on selection
                withAnimation(.easeInOut(duration: 0.15)) {
                    selectedSplit = split
                }
            }
        )
    }
}

#Preview {
    OnboardingSplitPreferenceView()
        .environmentObject(OnboardingViewModel.preview)
}
