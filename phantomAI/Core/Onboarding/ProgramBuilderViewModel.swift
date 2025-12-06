//
//  ProgramBuilderViewModel.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation
import Combine

/// ViewModel that manages program building state and progress
final class ProgramBuilderViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var progress: Double = 0.0
    @Published var statusText: String = "Analyzing your goals"
    @Published var generatedProgram: GeneratedProgram?
    @Published var isBuilding: Bool = false
    @Published var error: Error?
    
    // MARK: - Dependencies
    
    private var answers: OnboardingAnswers
    private let service: ProgramBuilderService
    private var cancellables = Set<AnyCancellable>()
    private var progressTimer: Timer?
    
    // MARK: - Status Steps
    
    private let statusSteps = [
        "Analyzing your goals",
        "Balancing training & recovery",
        "Creating week 1",
        "Finalizing your daily plan"
    ]
    
    // MARK: - Initialization
    
    init(answers: OnboardingAnswers, service: ProgramBuilderService = MockProgramBuilderService()) {
        self.answers = answers
        self.service = service
    }
    
    // MARK: - Actions
    
    /// Start the program building process
    func startBuilding(with answers: OnboardingAnswers? = nil) {
        guard !isBuilding else { return }
        
        // Update answers if provided
        if let newAnswers = answers {
            self.answers = newAnswers
        }
        
        isBuilding = true
        progress = 0.0
        statusText = statusSteps[0]
        generatedProgram = nil
        error = nil
        
        // Start progress animation
        startProgressAnimation()
        
        // Start actual program generation
        Task {
            do {
                let program = try await service.generateProgram(from: self.answers)
                
                await MainActor.run {
                    // Ensure progress reaches 100% before setting program
                    progress = 1.0
                    statusText = statusSteps.last ?? "Complete"
                    
                    // Small delay to show completion
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.generatedProgram = program
                        self.isBuilding = false
                        self.stopProgressAnimation()
                    }
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.isBuilding = false
                    self.stopProgressAnimation()
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func startProgressAnimation() {
        stopProgressAnimation()
        
        let duration: TimeInterval = 5.0 // 5 seconds total
        let steps = statusSteps.count
        let stepDuration = duration / Double(steps)
        
        var currentStep = 0
        
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            let elapsed = Date().timeIntervalSince(self.startTime)
            let targetProgress = min(0.95, elapsed / duration) // Cap at 95% until program is ready
            
            self.progress = targetProgress
            
            // Update status text based on progress
            let stepIndex = Int(elapsed / stepDuration)
            if stepIndex != currentStep && stepIndex < steps {
                currentStep = stepIndex
                self.statusText = self.statusSteps[min(stepIndex, steps - 1)]
            }
        }
    }
    
    private var startTime = Date()
    
    private func stopProgressAnimation() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
    
    deinit {
        stopProgressAnimation()
    }
}

