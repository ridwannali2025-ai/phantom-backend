//
//  OnboardingSelectableCard.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Reusable selectable card component for onboarding screens
struct OnboardingSelectableCard: View {
    let title: String
    let subtitle: String?
    let isSelected: Bool
    let onTap: () -> Void
    
    init(title: String, subtitle: String? = nil, isSelected: Bool, onTap: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.isSelected = isSelected
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 15))
                        .foregroundColor(isSelected ? .white.opacity(0.8) : Color(hex: "8A8A8E"))
                        .multilineTextAlignment(.leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 70)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color(hex: "A06AFE") : Color(hex: "F7F7F7"))
            )
            .shadow(
                color: isSelected ? Color(hex: "A06AFE").opacity(0.20) : Color.clear,
                radius: 24,
                x: 0,
                y: 8
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    VStack(spacing: 16) {
        OnboardingSelectableCard(
            title: "Build muscle",
            subtitle: nil,
            isSelected: false,
            onTap: {}
        )
        
        OnboardingSelectableCard(
            title: "Lose fat",
            subtitle: "Perfect for busy schedules",
            isSelected: true,
            onTap: {}
        )
    }
    .padding()
}

