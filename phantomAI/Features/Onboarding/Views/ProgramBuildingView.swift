//
//  ProgramBuildingView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Final onboarding step showing program building progress
struct ProgramBuildingView: View {
    let onFinished: () -> Void
    
    @State private var currentStepIndex = 0
    @State private var timer: Timer?
    
    private let loadingSteps = [
        "Analyzing your goals",
        "Balancing training & recovery",
        "Creating Week 1",
        "Finalizing your daily plan"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            OnboardingHeaderView(
                currentStep: .aiAnalysis,
                onBack: nil // no back from processing
            )
            .padding(.top, 8)
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 8) {
                Text("Designing your program…")
                    .font(.system(size: 24, weight: .semibold))
                Text("Sit tight while we tailor your training to your goals.")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "8A8A8E"))
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            Spacer(minLength: 32)
            
            // Loading steps
            VStack(alignment: .leading, spacing: 16) {
                loadingRow("Analyzing your goals", index: 0)
                loadingRow("Balancing training & recovery", index: 1)
                loadingRow("Creating Week 1", index: 2)
                loadingRow("Finalizing your daily plan", index: 3)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func loadingRow(_ text: String, index: Int) -> some View {
        HStack(spacing: 12) {
            if index < currentStepIndex {
                // Completed - show checkmark
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color(hex: "A06AFE"))
                    .font(.system(size: 20))
            } else if index == currentStepIndex {
                // Currently processing - show spinner
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(Color(hex: "A06AFE"))
            } else {
                // Not started yet - show empty circle
                Circle()
                    .fill(Color(hex: "E5E5EA"))
                    .frame(width: 20, height: 20)
            }
            
            Text(text)
                .font(.system(size: 16))
        }
        .opacity(index <= currentStepIndex ? 1.0 : 0.6)
        .animation(.easeInOut, value: currentStepIndex)
    }
    
    private func startTimer() {
        // Start with first step immediately
        currentStepIndex = 0
        
        // Advance to next step after 1.5 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            if currentStepIndex < loadingSteps.count - 1 {
                currentStepIndex += 1
            } else {
                stopTimer()
                // Wait a moment before finishing
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onFinished()
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    ProgramBuildingView {
        print("Program building finished")
    }
}

