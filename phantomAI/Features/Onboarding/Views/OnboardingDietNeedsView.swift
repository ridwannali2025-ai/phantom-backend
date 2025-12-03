//
//  OnboardingDietNeedsView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingDietNeedsView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("Dietary Needs")
                .font(.title)
                .bold()

            Text("Placeholder UI for the dietary needs step. We will design this later.")
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
    OnboardingDietNeedsView(viewModel: OnboardingViewModel())
}

