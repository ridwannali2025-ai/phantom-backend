//
//  OnboardingPastBlockersView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingPastBlockersView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @State private var selectedBlockers: Set<PastBlocker> = []

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(spacing: 32) {
                    // Title block
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What's holding you back?")
                            .font(.system(size: 32, weight: .bold))
                            .multilineTextAlignment(.leading)
                        
                        Text("Pick anything that has stopped you from reaching your goals in the past.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 32)
                    .padding(.horizontal, 24)

                    // Cards list (in specified order)
                    VStack(spacing: 12) {
                        ForEach(orderedBlockers) { blocker in
                            OnboardingSelectableCard(
                                title: blocker.rawValue,
                                subtitle: blocker.description,
                                isSelected: selectedBlockers.contains(blocker),
                                onTap: {
                                    toggle(blocker)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 24)

                    Spacer()
                        .frame(height: 40)
                }
            }

            // Bottom-anchored Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: !selectedBlockers.isEmpty,
                action: {
                    guard !selectedBlockers.isEmpty else { return }
                    onboarding.answers.pastBlockers = Array(selectedBlockers)
                    onboarding.goToNext()
                }
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Prefill from existing answers if user navigates back
            if let saved = onboarding.answers.pastBlockers {
                selectedBlockers = Set(saved)
            }
        }
    }
    
    // MARK: - Ordered Blockers
    
    /// Returns blockers in the specified display order
    private var orderedBlockers: [PastBlocker] {
        [
            .consistency,
            .unhealthyEating,
            .lackOfSupport,
            .busySchedule,
            .gymAnxiety,
            .lackOfKnowledge
        ]
    }
    
    // MARK: - Toggle Helper
    
    private func toggle(_ blocker: PastBlocker) {
        withAnimation(.easeInOut(duration: 0.15)) {
            if selectedBlockers.contains(blocker) {
                selectedBlockers.remove(blocker)
            } else {
                selectedBlockers.insert(blocker)
            }
        }
    }
}

#Preview {
    OnboardingPastBlockersView()
        .environmentObject(OnboardingViewModel.preview)
}




