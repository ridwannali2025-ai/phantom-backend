//
//  OnboardingCoachResultsView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingCoachResultsView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Title & subtitle
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phantom helps you get long-term results.")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("Most people fall off when they try to do everything alone. Phantom keeps you accountable and adjusts your plan as life happens.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 24)

                    // Comparison card
                    comparisonCard
                        .padding(.horizontal, 24)

                    Spacer()
                        .frame(height: 40)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Bottom-anchored Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: true
            ) {
                onboarding.goToNext()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
    }
    
    // MARK: - Comparison Card
    
    private var comparisonCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your progress over time")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            
            // Simple stylized "graph" using curves and labels
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(hex: "F7F7F7"))
                
                VStack(spacing: 16) {
                    // Graph area
                    GeometryReader { geo in
                        ZStack {
                            // Baseline grid
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "E5E5EA"), lineWidth: 1)
                            
                            // "On your own" line (fades / drops off)
                            Path { path in
                                let w = geo.size.width
                                let h = geo.size.height
                                path.move(to: CGPoint(x: 0.05 * w, y: 0.45 * h))
                                path.addCurve(
                                    to: CGPoint(x: 0.95 * w, y: 0.80 * h),
                                    control1: CGPoint(x: 0.35 * w, y: 0.55 * h),
                                    control2: CGPoint(x: 0.65 * w, y: 0.75 * h)
                                )
                            }
                            .stroke(Color.red.opacity(0.65), lineWidth: 3)
                            
                            // "With Phantom" line (more stable / improving)
                            Path { path in
                                let w = geo.size.width
                                let h = geo.size.height
                                path.move(to: CGPoint(x: 0.05 * w, y: 0.55 * h))
                                path.addCurve(
                                    to: CGPoint(x: 0.95 * w, y: 0.30 * h),
                                    control1: CGPoint(x: 0.35 * w, y: 0.50 * h),
                                    control2: CGPoint(x: 0.65 * w, y: 0.35 * h)
                                )
                            }
                            .stroke(Color(hex: "A06AFE"), lineWidth: 3)
                        }
                    }
                    .frame(height: 160)
                    
                    // Legend
                    HStack {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color(hex: "A06AFE"))
                                .frame(width: 10, height: 10)
                            Text("With Phantom")
                                .font(.system(size: 14))
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.red.opacity(0.7))
                                .frame(width: 10, height: 10)
                            Text("On your own")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(16)
            }
            
            // Supporting copy
            Text("Phantom focuses on habits, not quick fixes—so your results stick even months down the road.")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(hex: "F7F7F7"))
        )
    }
}

#Preview {
    OnboardingCoachResultsView()
        .environmentObject(OnboardingViewModel.preview)
}

