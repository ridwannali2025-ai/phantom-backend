//
//  OnboardingAIAnalysisView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingAIAnalysisView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("AI Analysis")
                .font(.title)
                .bold()

            Text("Placeholder UI for the AI analysis step. We will design this later.")
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
    OnboardingAIAnalysisView(viewModel: OnboardingViewModel())
}




