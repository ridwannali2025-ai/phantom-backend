//
//  ProgramBuilderViewModel.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import Foundation
import SwiftUI
import Combine

final class ProgramBuilderViewModel: ObservableObject {
    // MARK: - Published state for the UI
    
    @Published var progress: Double = 0.0        // 0.0 – 1.0
    @Published var percentageText: String = "0%"
    @Published var currentStepTitle: String = "Analyzing your goals…"
    @Published var steps: [ProgramBuildStep] = []
    @Published var isFinished: Bool = false
    
    // Store the request/answers if needed
    let request: ProgramRequest
    
    // MARK: - Init
    
    init(request: ProgramRequest) {
        self.request = request
        
        self.steps = [
            ProgramBuildStep(title: "Analyzing your goals"),
            ProgramBuildStep(title: "Balancing training & recovery"),
            ProgramBuildStep(title: "Creating Week 1"),
            ProgramBuildStep(title: "Finalizing your daily plan")
        ]
        
        self.updateProgress(stepIndex: 0)
    }
    
    // MARK: - Public API
    
    func startBuilding(after delay: TimeInterval = 0.5,
                       stepDuration: TimeInterval = 1.0,
                       completion: @escaping (GeneratedProgram) -> Void)
    {
        // Simulate multi-step progress locally.
        // No AI or network calls here yet: just a fake progress animation.
        
        let totalSteps = steps.count
        guard totalSteps > 0 else {
            self.finish(with: completion)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.runStep(at: 0,
                         totalSteps: totalSteps,
                         stepDuration: stepDuration,
                         completion: completion)
        }
    }
    
    // MARK: - Private helpers
    
    private func runStep(at index: Int,
                         totalSteps: Int,
                         stepDuration: TimeInterval,
                         completion: @escaping (GeneratedProgram) -> Void)
    {
        guard index < totalSteps else {
            self.finish(with: completion)
            return
        }
        
        updateProgress(stepIndex: index)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration) {
            let nextIndex = index + 1
            if nextIndex < totalSteps {
                self.runStep(at: nextIndex,
                             totalSteps: totalSteps,
                             stepDuration: stepDuration,
                             completion: completion)
            } else {
                self.finish(with: completion)
            }
        }
    }
    
    private func updateProgress(stepIndex: Int) {
        let total = max(steps.count, 1)
        let fraction = Double(stepIndex + 1) / Double(total)
        self.progress = fraction
        self.percentageText = "\(Int(fraction * 100))%"
        
        if stepIndex < steps.count {
            self.currentStepTitle = steps[stepIndex].title
        }
    }
    
    private func finish(with completion: @escaping (GeneratedProgram) -> Void) {
        self.progress = 1.0
        self.percentageText = "100%"
        self.isFinished = true
        
        // For now, create a simple placeholder GeneratedProgram
        // using the ProgramRequest (or sensible defaults).
        let placeholder = GeneratedProgram.placeholder(from: request)
        completion(placeholder)
    }
}

// MARK: - ProgramBuildStep

struct ProgramBuildStep: Identifiable {
    let id = UUID()
    let title: String
}

