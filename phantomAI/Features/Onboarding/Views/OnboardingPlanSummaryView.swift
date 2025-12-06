//
//  OnboardingPlanSummaryView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingPlanSummaryView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView
            
            if let program = onboarding.generatedProgram {
                // Main content with program
                ZStack(alignment: .bottom) {
                    // ScrollView for content
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            // A. Program Header
                            programHeader(program: program)
                            
                            // B. Divider
                            Divider()
                                .padding(.vertical, 8)
                            
                            // C. Your Training Days Section
                            trainingDaysSection(program: program)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 80) // Leave space for button
                    }
                    
                    // Continue Button (anchored at bottom)
                    VStack {
                        Spacer()
                        PrimaryContinueButton(
                            title: "Continue",
                            isEnabled: true,
                            action: {
                                onboarding.goToNext()
                            }
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                    }
                }
            } else {
                // Show fallback view for nil program
                VStack(spacing: 16) {
                    Text("No program found")
                        .font(.title2)
                        .bold()
                    
                    Text("Please go back and regenerate your plan.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding()
            }
        }
        .background(Color.white.ignoresSafeArea())
    }
    
    // MARK: - Program Header
    
    private func programHeader(program: Program) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Program name
            Text(program.name)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.primary)
            
            // Program description
            Text(program.description)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            // Stats row
            HStack(spacing: 20) {
                Text("Duration: \(calculateWeeks(program: program)) weeks")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Days per week: \(calculateDaysPerWeek(program: program))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 4)
        }
    }
    
    // MARK: - Training Days Section
    
    private func trainingDaysSection(program: Program) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Training Days")
                .font(.headline)
                .foregroundColor(.primary)
            
            // Unique workouts (one card per workout type)
            ForEach(uniqueWorkouts(from: program.workouts)) { workout in
                workoutCard(workout: workout)
            }
        }
    }
    
    // MARK: - Workout Card
    
    private func workoutCard(workout: Program.WorkoutPlan) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            // Workout name
            Text(workout.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            // Exercise count
            Text("\(workout.exercises.count) exercises")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Optional: basic volume summary
            if let summary = workoutSummary(workout: workout) {
                Text(summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    // MARK: - Helper Functions
    
    private func calculateWeeks(program: Program) -> Int {
        guard let endDate = program.endDate else {
            // If no end date, estimate from workouts
            return 4 // Default fallback
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekOfYear], from: program.startDate, to: endDate)
        return max(components.weekOfYear ?? 4, 1)
    }
    
    private func calculateDaysPerWeek(program: Program) -> Int {
        // Count unique workout types (workouts array contains one of each type)
        let uniqueWorkoutNames = Set(program.workouts.map { $0.name })
        return uniqueWorkoutNames.count
    }
    
    private func uniqueWorkouts(from workouts: [Program.WorkoutPlan]) -> [Program.WorkoutPlan] {
        // Return one of each unique workout type
        var seen = Set<String>()
        var unique: [Program.WorkoutPlan] = []
        
        for workout in workouts {
            if !seen.contains(workout.name) {
                seen.insert(workout.name)
                unique.append(workout)
            }
        }
        
        return unique
    }
    
    private func workoutSummary(workout: Program.WorkoutPlan) -> String? {
        guard !workout.exercises.isEmpty else { return nil }
        
        // Calculate average sets and reps
        let totalSets = workout.exercises.reduce(0) { $0 + $1.sets }
        let avgSets = totalSets / workout.exercises.count
        
        let repsWithValues = workout.exercises.compactMap { $0.reps }
        guard !repsWithValues.isEmpty else { return nil }
        let avgReps = repsWithValues.reduce(0, +) / repsWithValues.count
        
        return "Average \(avgReps)x\(avgSets) per exercise"
    }
}

#Preview {
    OnboardingPlanSummaryView()
        .environmentObject(OnboardingViewModel.preview)
}
