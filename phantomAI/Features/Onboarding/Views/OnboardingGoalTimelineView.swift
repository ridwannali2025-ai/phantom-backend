//
//  OnboardingGoalTimelineView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingGoalTimelineView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title & subtitle with generous spacing
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How fast do you want to reach your goal?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 24)

                    // Slider view (always shown)
                    timelineSliderView
                        .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Bottom-anchored Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: true,
                action: {
                    viewModel.goNext()
                }
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
    }
    
    // MARK: - Timeline Slider View
    
    private var timelineSliderView: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(minHeight: 20)
            
            // Label
            Text("Target timeline")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 24)
            
            // Large dynamic duration text - bold, ~32pt, centered
            Text(currentDurationLabel)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 32)
            
            // Icons row directly above slider
            HStack {
                Image(systemName: "tortoise.fill")
                    .font(.system(size: 22))
                    .foregroundColor(colorForDuration(.sustainable))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "hare.fill")
                    .font(.system(size: 22))
                    .foregroundColor(colorForDuration(.moderate))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Image(systemName: "figure.run")
                    .font(.system(size: 22))
                    .foregroundColor(colorForDuration(.aggressive))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.bottom, 12)
            
            // Slider
            Slider(value: $viewModel.weeklyFatLoss, in: 0.3...1.5, step: 0.1)
                .tint(Color(hex: "A06AFE"))
            
            // Label row under slider
            HStack {
                Text("Slow")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                
                Text("Moderate")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                
                Text("Fast")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            .padding(.top, 4)
            .padding(.bottom, 40)
            
            // Recommended pill-style button
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    viewModel.weeklyFatLoss = 0.8
                }
            }) {
                Text("Recommended")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "F7F7F7"),
                                Color(hex: "F0F0F0")
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)
            
            Spacer()
                .frame(minHeight: 20)
        }
    }
    
    // MARK: - Helper Computed Properties
    
    private var currentDurationLabel: String {
        let value = viewModel.weeklyFatLoss
        if value < 0.55 {
            return "1 year"
        } else if value <= 1.0 {
            return "6 months"
        } else {
            return "3 months"
        }
    }
    
    private func colorForDuration(_ timeline: OnboardingViewModel.GoalTimeline) -> Color {
        let value = viewModel.weeklyFatLoss
        let current: OnboardingViewModel.GoalTimeline
        if value < 0.55 {
            current = .sustainable
        } else if value <= 1.0 {
            current = .moderate
        } else {
            current = .aggressive
        }
        return current == timeline ? Color(hex: "A06AFE") : .secondary
    }
}

#Preview {
    let vm = OnboardingViewModel.preview
    return OnboardingGoalTimelineView(viewModel: vm)
}
