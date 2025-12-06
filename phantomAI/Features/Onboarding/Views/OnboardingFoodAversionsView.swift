//
//  OnboardingFoodAversionsView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingFoodAversionsView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @State private var avoidFoodsText: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title & subtitle with generous spacing
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Any foods you want to avoid?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("Optional—but helps us personalize nutrition guidance.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 32)
                    .padding(.horizontal, 24)

                    // TextEditor for foods to avoid
                    VStack(alignment: .leading, spacing: 8) {
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemGray6))
                                .frame(height: 120)
                            
                            if avoidFoodsText.isEmpty {
                                Text("Example: seafood, peanuts, mushrooms…")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.secondary.opacity(0.6))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .allowsHitTesting(false)
                            }
                            
                            TextEditor(text: $avoidFoodsText)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.primary)
                                .scrollContentBackground(.hidden)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .frame(height: 120)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Bottom-anchored Continue button (always enabled)
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: true,
                action: {
                    let trimmed = avoidFoodsText.trimmingCharacters(in: .whitespacesAndNewlines)
                    if trimmed.isEmpty {
                        onboarding.answers.avoidFoods = nil
                    } else {
                        onboarding.answers.avoidFoods = trimmed
                    }
                    onboarding.goToNext()
                }
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Prefill from existing answers if user navigates back
            if let saved = onboarding.answers.avoidFoods {
                avoidFoodsText = saved
            }
        }
    }
}

#Preview {
    OnboardingFoodAversionsView()
        .environmentObject(OnboardingViewModel.preview)
}




