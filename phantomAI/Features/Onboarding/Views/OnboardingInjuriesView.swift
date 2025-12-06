//
//  OnboardingInjuriesView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingInjuriesView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @State private var hasInjuries: Bool? = nil
    @State private var details: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title & subtitle with generous spacing
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Any injuries or pain we should know about?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("We'll avoid movements that could aggravate problem areas.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 32)
                    .padding(.horizontal, 24)

                    // Yes/No toggle buttons
                    VStack(spacing: 12) {
                        injuryTogglePill(value: false, label: "No, I'm good")
                        injuryTogglePill(value: true, label: "Yes, I have injuries")
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)

                    // TextEditor for details (only shown when Yes is selected)
                    if hasInjuries == true {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Describe any past or current injuries (e.g., lower back, knees, shoulders)...")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 24)
                            
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemGray6))
                                    .frame(height: 120)
                                
                                if details.isEmpty {
                                    Text("Describe any past or current injuries (e.g., lower back, knees, shoulders)...")
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(.secondary.opacity(0.6))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .allowsHitTesting(false)
                                }
                                
                                TextEditor(text: $details)
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.primary)
                                    .scrollContentBackground(.hidden)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(height: 120)
                            }
                            .padding(.horizontal, 24)
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Bottom-anchored Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: hasInjuries != nil && (hasInjuries == false || !details.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty),
                action: {
                    guard let hasInjuries else { return }
                    
                    onboarding.answers.hasInjuries = hasInjuries
                    onboarding.answers.injuryDetails = hasInjuries ? details.trimmingCharacters(in: .whitespacesAndNewlines) : nil
                    
                    onboarding.goToNext()
                }
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Prefill from existing answers if user navigates back
            if let saved = onboarding.answers.hasInjuries {
                hasInjuries = saved
            }
            if let savedDetails = onboarding.answers.injuryDetails {
                details = savedDetails
            }
        }
    }
    
    // MARK: - Injury Toggle Pill
    
    private func injuryTogglePill(value: Bool, label: String) -> some View {
        let isSelected = hasInjuries == value
        
        return Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) {
                hasInjuries = value
                // Clear details if user switches to "No"
                if value == false {
                    details = ""
                }
            }
        }) {
            HStack(spacing: 12) {
                Text(label)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .primary)
                
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
    OnboardingInjuriesView()
        .environmentObject(OnboardingViewModel.preview)
}




