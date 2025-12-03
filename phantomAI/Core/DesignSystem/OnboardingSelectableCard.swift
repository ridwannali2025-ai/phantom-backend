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
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "8A8A8E"))
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "A259FF"))
                        .font(.system(size: 24))
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "F5F5F7"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color(hex: "A259FF") : Color.clear, lineWidth: 2)
            )
            .shadow(color: isSelected ? Color.black.opacity(0.1) : Color.clear, radius: 8, x: 0, y: 4)
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

