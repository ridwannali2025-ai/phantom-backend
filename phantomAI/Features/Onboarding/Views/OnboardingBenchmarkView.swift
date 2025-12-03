//
//  OnboardingBenchmarkView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingBenchmarkView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("Fitness Benchmark")
                .font(.title)
                .bold()

            Text("Placeholder UI for the fitness benchmark step. We will design this later.")
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
    OnboardingBenchmarkView(viewModel: OnboardingViewModel())
}

