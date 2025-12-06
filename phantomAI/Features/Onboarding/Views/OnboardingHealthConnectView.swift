//
//  OnboardingHealthConnectView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingHealthConnectView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel

    var body: some View {
        VStack(spacing: 24) {
            Spacer().frame(height: 40)

            // Icon placeholder
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
                    .frame(width: 200, height: 200)

                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.pink)
            }

            VStack(spacing: 12) {
                Text("Connect Apple Health")
                    .font(.system(size: 26, weight: .bold))
                    .multilineTextAlignment(.center)

                Text("We'll use your activity and health data to better tune your training, recovery, and calorie estimates.")
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "figure.run.circle.fill")
                    Text("Smarter training load and recovery")
                }
                HStack(spacing: 12) {
                    Image(systemName: "flame.circle.fill")
                    Text("Better calorie and expenditure estimates")
                }
                HStack(spacing: 12) {
                    Image(systemName: "chart.bar.fill")
                    Text("More accurate progress tracking over time")
                }
            }
            .font(.system(size: 15))
            .foregroundColor(.primary)
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(.systemGray6))
            )
            .padding(.horizontal, 24)

            Spacer()

            VStack(spacing: 12) {
                Button(action: {
                    // TODO: Hook up real HealthKit permission request.
                    // For now, just advance in onboarding so the flow continues.
                    onboarding.goToNext()
                }) {
                    Text("Connect Apple Health")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(999)
                }

                Button(action: {
                    // Skip for now
                    onboarding.goToNext()
                }) {
                    Text("Skip for now")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview {
    OnboardingHealthConnectView()
        .environmentObject(OnboardingViewModel.preview)
}

