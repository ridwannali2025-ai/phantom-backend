//
//  OnboardingWorkoutTimeView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingWorkoutTimeView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("Workout Time")
                .font(.title)
                .bold()

            Text("Placeholder UI for the workout time step. We will design this later.")
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
    OnboardingWorkoutTimeView(viewModel: OnboardingViewModel())
}


