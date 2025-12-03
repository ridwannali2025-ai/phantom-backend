//
//  OnboardingGoalTimelineView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Onboarding screen for selecting goal timeline
struct OnboardingGoalTimelineView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("Goal Timeline")
                .font(.title)
                .bold()

            Text("Placeholder UI for the goal timeline step. We will design this later.")
                .multilineTextAlignment(.center)

            Button("Continue") {
                viewModel.goNext()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    OnboardingGoalTimelineView(viewModel: OnboardingViewModel())
}

