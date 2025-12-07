//
//  ProgramBuildingView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct ProgramBuildingView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @State private var builder: ProgramBuilderViewModel?
    
    private var request: ProgramRequest {
        onboarding.programRequest
    }

    var body: some View {
        Group {
            if let builder = builder {
                ProgramBuildingContentView(builder: builder)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if builder == nil {
                builder = ProgramBuilderViewModel(request: request)
                
                builder?.startBuilding { program in
                    // When finished, create onboarding.generatedPlan from `program`
                    let plan = GeneratedPlan(
                        caloriesPerDay: program.nutritionPlan.targetCalories,
                        proteinGrams: program.nutritionPlan.proteinGrams,
                        carbsGrams: program.nutritionPlan.carbGrams,
                        fatsGrams: program.nutritionPlan.fatGrams,
                        trainingSplitTitle: "First week schedule",
                        trainingSplitSubtitle: "Full program unlocked after you start"
                    )
                    onboarding.generatedPlan = plan
                    onboarding.goToNext()   // move to plan summary
                }
            }
        }
    }
}

private struct ProgramBuildingContentView: View {
    @ObservedObject var builder: ProgramBuilderViewModel
    
    var body: some View {
        VStack(spacing: 32) {
            Text(builder.percentageText)
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(Color(hex: "A06AFE"))

            Text("We're setting everything up for you")
                .font(.title3.bold())
                .multilineTextAlignment(.center)

            ProgressView(value: builder.progress, total: 1.0)
                .tint(Color(hex: "A06AFE"))
                .padding(.horizontal, 32)

            Text(builder.currentStepTitle)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    ProgramBuildingView()
        .environmentObject(OnboardingViewModel.preview)
        .environment(\.container, AppContainer.preview)
}
