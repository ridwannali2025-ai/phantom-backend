//
//  OnboardingTrustView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingTrustView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel

    var body: some View {
        VStack(spacing: 32) {
            Spacer().frame(height: 40)

            // Illustration placeholder (we can swap the asset later)
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.96, green: 0.92, blue: 1.0),
                                Color(red: 0.92, green: 0.96, blue: 1.0)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 220, height: 220)

                Image(systemName: "hands.clap.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.primary)
            }

            VStack(spacing: 12) {
                Text("Thank you for trusting Phantom")
                    .font(.system(size: 26, weight: .bold))
                    .multilineTextAlignment(.center)

                Text("Now let's personalize Phantom for you…")
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)

            VStack(spacing: 12) {
                Text("Your privacy and security matter to us.")
                    .font(.system(size: 17, weight: .semibold))
                    .multilineTextAlignment(.center)

                Text("We only use your information to create your plan and track your progress. You can export or delete your data anytime.")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(.systemGray6))
            )
            .padding(.horizontal, 24)

            Spacer()

            PrimaryContinueButton(
                title: "Continue",
                isEnabled: true,
                action: {
                    onboarding.goToNext()
                }
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview {
    OnboardingTrustView()
        .environmentObject(OnboardingViewModel.preview)
}

