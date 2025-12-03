//
//  OnboardingSleepView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingSleepView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("Sleep Hours")
                .font(.title)
                .bold()

            Text("Placeholder UI for the sleep hours step. We will design this later.")
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
    OnboardingSleepView(viewModel: OnboardingViewModel())
}

