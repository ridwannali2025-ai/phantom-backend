//
//  OnboardingSessionLengthView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingSessionLengthView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("Session Length")
                .font(.title)
                .bold()

            Text("Placeholder UI for the session length step. We will design this later.")
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
    OnboardingSessionLengthView(viewModel: OnboardingViewModel())
}

