//
//  OnboardingCookingSkillView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingCookingSkillView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("Cooking Skill")
                .font(.title)
                .bold()

            Text("Placeholder UI for the cooking skill step. We will design this later.")
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
    OnboardingCookingSkillView(viewModel: OnboardingViewModel())
}


