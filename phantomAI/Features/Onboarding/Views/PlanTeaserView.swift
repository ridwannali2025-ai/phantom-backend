//
//  PlanTeaserView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct PlanTeaserView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Header (navigation bar + progress bar) is already provided by OnboardingFlowView
            
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 60)
                    
                    // Main Icon Section (Centered)
                    ZStack {
                        // Soft glow behind
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color(hex: "A06AFE").opacity(0.15),
                                        Color(hex: "6C4BFF").opacity(0.1),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 60,
                                    endRadius: 120
                                )
                            )
                            .frame(width: 240, height: 240)
                            .blur(radius: 20)
                        
                        // Large circular gradient orb
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "A06AFE"),
                                        Color(hex: "6C4BFF")
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 180, height: 180)
                            .shadow(color: Color(hex: "A06AFE").opacity(0.3), radius: 24, x: 0, y: 8)
                        
                        // Hands clapping icon (outlined style)
                        Image(systemName: "hands.clap")
                            .font(.system(size: 64, weight: .medium))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "A06AFE"),
                                        Color(hex: "6C4BFF")
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .symbolVariant(.fill)
                    }
                    .padding(.bottom, 40)
                    
                    // Headline (Centered, bold)
                    Text("Your profile is ready.")
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .foregroundColor(Color(hex: "000000"))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 16)
                    
                    // Subtitle (Centered, lighter)
                    Text("We've analyzed your goals, availability, and training history.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color(hex: "8A8A8A"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 32)
                    
                    // Info Card (Centered below subtitle)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            // Sparkle icon
                            Image(systemName: "sparkles")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color(hex: "A06AFE"),
                                            Color(hex: "6C4BFF")
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            // Title
                            Text("What happens next")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        
                        // Body text
                        Text("Phantom will design your workout structure, calibrate your daily fuel targets, and build your personalized Week 1 program.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Color(hex: "8A8A8A"))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(hex: "F7F5FF"))
                            .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                    .padding(.horizontal, 32)
                    
                    Spacer()
                        .frame(height: 60)
                }
                .frame(maxWidth: .infinity)
            }
            
            // Button (Bottom, full-width)
            Button(action: {
                onboarding.goToNext()
            }) {
                Text("Generate my custom plan")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(hex: "A06AFE"),
                                Color(hex: "6C4BFF")
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(20)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview {
    PlanTeaserView()
        .environmentObject(OnboardingViewModel.preview)
}
