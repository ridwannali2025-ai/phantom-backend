//
//  WelcomeView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct WelcomeView: View {
    let onGetStarted: () -> Void
    let onSignIn: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Logo
            Image("appLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .padding(.bottom, 40)
            
            // Title
            Text("Your AI Trainer Awaits")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(Color(hex: "1D1D1F"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 16)
            
            // Subtitle
            Text("Personalized workouts, nutrition guidance, and progress tracking—all powered by AI")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(hex: "8A8A8E"))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            
            // Get Started Button
            Button(action: onGetStarted) {
                Text("Get Started")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "A06AFE"),
                                Color(hex: "7366FF")
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(26)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            
            // Sign In Button
            Button(action: onSignIn) {
                Text("Sign In")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "7366FF"))
            }
            .padding(.bottom, 40)
            
            Spacer()
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    WelcomeView(
        onGetStarted: {},
        onSignIn: {}
    )
}

