//
//  OnboardingPrimaryGoalView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingPrimaryGoalView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("Primary Goal")
                .font(.title)
                .bold()

            Text("Placeholder UI for the primary goal step. We will design this later.")
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
    OnboardingPrimaryGoalView(viewModel: OnboardingViewModel())
}

