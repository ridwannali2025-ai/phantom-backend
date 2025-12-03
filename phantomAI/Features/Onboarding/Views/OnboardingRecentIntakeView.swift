//
//  OnboardingRecentIntakeView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingRecentIntakeView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("Recent Intake")
                .font(.title)
                .bold()

            Text("Placeholder UI for the recent intake step. We will design this later.")
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
    OnboardingRecentIntakeView(viewModel: OnboardingViewModel())
}

