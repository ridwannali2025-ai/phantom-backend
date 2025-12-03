//
//  PrimaryContinueButton.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Primary continue button for onboarding screens
struct PrimaryContinueButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    Group {
                        if isEnabled {
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(hex: "A06AFE"),
                                    Color(hex: "7366FF")
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        } else {
                            Color(hex: "D1D1D6")
                        }
                    }
                )
                .clipShape(Capsule())
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryContinueButton(
            title: "Continue",
            isEnabled: false,
            action: {}
        )
        
        PrimaryContinueButton(
            title: "Continue",
            isEnabled: true,
            action: {}
        )
    }
    .padding()
}

