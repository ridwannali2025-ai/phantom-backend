//
//  ProgramBuildingView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Premium loading screen that generates the program using AI
struct ProgramBuildingView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @StateObject private var builderViewModel: ProgramBuilderViewModel
    
    init() {
        // Initialize with placeholder - will be set in onAppear with actual answers
        _builderViewModel = StateObject(wrappedValue: ProgramBuilderViewModel(answers: OnboardingAnswers()))
    }
    
    var body: some View {
        // Header is already provided by OnboardingFlowView
        Group {
            if builderViewModel.error != nil {
                errorView(message: builderViewModel.error?.localizedDescription ?? "Failed to generate program")
            } else {
                loadingView
            }
        }
        .background(
            ZStack {
                Color(uiColor: .systemBackground)
                LinearGradient(
                    colors: [
                        Color(uiColor: .systemBackground),
                        Color(red: 0.96, green: 0.94, blue: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .ignoresSafeArea()
        )
        .onAppear {
            // Debug: Print full onboarding answers payload
            print("ONBOARDING ANSWERS:", onboarding.answers)
            
            // Debug: Print program request
            let request = onboarding.programRequest
            print("PROGRAM REQUEST:", request)
            
            // Start building if not already started
            if !builderViewModel.isBuilding && builderViewModel.generatedProgram == nil {
                builderViewModel.startBuilding(with: onboarding.answers)
            }
        }
        .onChange(of: builderViewModel.generatedProgram?.id ?? "") { oldValue, newValue in
            // When program is ready (id changes from empty to actual id), save it and navigate
            if let program = builderViewModel.generatedProgram {
                // Save the full program
                onboarding.generatedProgram = program.toProgram(userId: "temp-user-id")
                
                // Create and save GeneratedPlan for the summary view
                let nutritionPlan = program.nutritionPlan
                onboarding.generatedPlan = GeneratedPlan(
                    caloriesPerDay: nutritionPlan.targetCalories,
                    proteinGrams: nutritionPlan.proteinGrams,
                    carbsGrams: nutritionPlan.carbGrams,
                    fatsGrams: nutritionPlan.fatGrams,
                    trainingSplitTitle: "First week meal goal",
                    trainingSplitSubtitle: "Full schedule unlocked after you start your first session."
                )
                
                // Debug: Print generated plan
                print("GENERATED PLAN CREATED:", onboarding.generatedPlan as Any)
                
                // Navigate to next step (plan summary)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onboarding.goToNext()
                }
            }
        }
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 24) {
                // Premium progress ring
                ProgressRingView(percent: Int(builderViewModel.progress * 100))
                
                // Main title
                Text("We're setting everything up for you")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(.top, 24)
                
                // Dynamic subtitle with fade animation
                Text(builderViewModel.statusText)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                    .padding(.horizontal, 32)
                    .animation(.easeInOut(duration: 0.3), value: builderViewModel.statusText)
            }
            
            Spacer()
            
            // Helper text at bottom
            Text("Phantom is tailoring your training, nutrition, and recovery in real time.")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
        }
    }
    
    // MARK: - Progress Ring View
    
    struct ProgressRingView: View {
        let percent: Int   // 0–100
        
        var body: some View {
            ZStack {
                // Soft RadialGradient halo behind
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(hex: "A06AFE").opacity(0.15),
                                Color(hex: "7B5CFF").opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 60,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .blur(radius: 30)
                
                // Background circle
                Circle()
                    .stroke(
                        Color(.systemGray5).opacity(0.3),
                        lineWidth: 18
                    )
                    .frame(width: 180, height: 180)
                
                // Progress ring with gradient
                Circle()
                    .trim(from: 0, to: CGFloat(percent) / 100)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(hex: "A06AFE"),
                                Color(hex: "7B5CFF")
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 18, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: 180, height: 180)
                    .shadow(color: Color(hex: "A06AFE").opacity(0.3), radius: 16, x: 0, y: 0)
                    .animation(.easeOut(duration: 0.05), value: percent)
                
                // Percentage text in center
                Text("\(percent)%")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
            }
            .frame(width: 200, height: 200)
        }
    }
    
    // MARK: - Error View
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 64))
                .foregroundColor(.orange)
            
            Text("Something went wrong")
                .font(.system(size: 28, weight: .bold))
            
            Text(message)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button("Try Again") {
                builderViewModel.startBuilding()
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(hex: "A06AFE"))
            
            Spacer()
        }
    }
}

#Preview {
    ProgramBuildingView()
        .environmentObject(OnboardingViewModel.preview)
        .environment(\.container, AppContainer.preview)
}
