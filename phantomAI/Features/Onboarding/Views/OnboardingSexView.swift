//
//  OnboardingSexView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingSexView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @State private var selectedSex: SexType? = nil

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title & subtitle with generous spacing
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What's your sex?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("This refines your calorie targets and training recommendations.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 32)
                    .padding(.horizontal, 24)

                    // Sex selection pills
                    VStack(spacing: 12) {
                        let orderedSexes: [SexType] = [.male, .female, .other]
                        ForEach(orderedSexes, id: \.self) { sexOption in
                            sexPill(sexOption, label: sexOption.title)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Bottom-anchored Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: selectedSex != nil,
                action: {
                    guard let selectedSex else { return }
                    onboarding.answers.sex = selectedSex
                    onboarding.goToNext()
                }
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Prefill sex if user navigates back
            if let savedSex = onboarding.answers.sex {
                selectedSex = savedSex
            }
        }
    }
    
    // MARK: - Sex Pill
    
    private func sexPill(_ type: SexType, label: String) -> some View {
        Button {
            selectedSex = type
        } label: {
            Text(label)
                .frame(maxWidth: .infinity)
                .padding()
                .background(selectedSex == type ? Color(hex: "A06AFE") : Color(.systemBackground))
                .foregroundColor(selectedSex == type ? .white : .primary)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

#Preview {
    OnboardingSexView()
        .environmentObject(OnboardingViewModel.preview)
}

