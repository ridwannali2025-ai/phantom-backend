//
//  WelcomeView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Welcome screen shown to new users before authentication
struct WelcomeView: View {
    let onGetStarted: () -> Void
    let onAlreadyHaveAccount: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Title
            Text("Your AI Fitness Coach")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            // Subpoints
            VStack(alignment: .leading, spacing: 16) {
                FeatureRow(icon: "person.fill", text: "Personalized training")
                FeatureRow(icon: "brain.head.profile", text: "Smart AI coaching")
                FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Meal tracking & progress monitoring")
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            // Buttons
            VStack(spacing: 16) {
                Button(action: onGetStarted) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                }
                
                Button(action: onAlreadyHaveAccount) {
                    Text("I already have an account")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(Color.white)
    }
}

/// Feature row component for welcome screen
private struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 24)
            Text(text)
                .font(.body)
        }
    }
}

#Preview {
    WelcomeView(
        onGetStarted: { print("Get Started tapped") },
        onAlreadyHaveAccount: { print("Already have account tapped") }
    )
}


