//
//  ProgramBuildingView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Final onboarding step showing program building progress
struct ProgramBuildingView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @Environment(\.container) private var container
    
    enum ProgramBuildState {
        case idle
        case loading
        case success(Program)
        case error(String)
    }
    
    @State private var state: ProgramBuildState = .idle
    @State private var currentStepIndex = 0
    @State private var timer: Timer?
    
    private let loadingSteps = [
        "Analyzing your goals",
        "Balancing training & recovery",
        "Creating Week 1",
        "Finalizing your daily plan"
    ]
    
    var body: some View {
        // Content based on state
        // Note: Header/progress is provided by OnboardingFlowView
        Group {
            switch state {
            case .idle, .loading:
                loadingView
            case .success(let program):
                successView(program: program)
            case .error(let message):
                errorView(message: message)
            }
        }
        .background(Color(.systemBackground))
        .onAppear {
            if case .idle = state {
                startProgramGeneration()
            }
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack(spacing: 0) {
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
    }
    
    // MARK: - Success View
    
    private func successView(program: Program) -> some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(Color(hex: "A06AFE"))
            
            Text("Program Ready!")
                .font(.system(size: 28, weight: .bold))
            
            VStack(spacing: 8) {
                Text(program.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(program.description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            Button("Continue") {
                onboarding.goToNext()
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
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
                state = .idle
                startProgramGeneration()
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
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
    
    // MARK: - Program Generation
    
    private func startProgramGeneration() {
        // Validate we can create a ProgramRequest
        guard let request = onboarding.makeProgramRequest() else {
            state = .error("Missing required information. Please complete all onboarding steps.")
            return
        }
        
        // Start loading state
        state = .loading
        startTimer()
        
        // Generate program using AI service
        Task {
            do {
                let program = try await container.aiService.buildProgram(for: request)
                
                // Update UI on main thread
                await MainActor.run {
                    stopTimer()
                    state = .success(program)
                    onboarding.generatedProgram = program
                }
            } catch {
                // Handle error on main thread
                await MainActor.run {
                    stopTimer()
                    state = .error(error.localizedDescription)
                }
            }
        }
    }
    
    private func startTimer() {
        // Start with first step immediately
        currentStepIndex = 0
        
        // Advance to next step after 1.5 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            if currentStepIndex < loadingSteps.count - 1 {
                currentStepIndex += 1
            } else {
                // Keep showing loading until program is generated
                // Timer will be stopped when state changes to success/error
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    ProgramBuildingView()
        .environmentObject(OnboardingViewModel.preview)
        .environment(\.container, AppContainer.preview)
}

