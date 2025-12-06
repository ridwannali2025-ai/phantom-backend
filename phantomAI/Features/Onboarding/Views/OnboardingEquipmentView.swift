//
//  OnboardingEquipmentView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingEquipmentView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @State private var selectedEquipment: Set<EquipmentOption> = []

    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title & subtitle with generous spacing
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Equipment Access")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("What equipment do you have access to?")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 32)
                    .padding(.horizontal, 24)

                    // Equipment selection cards (multi-select)
                    VStack(spacing: 12) {
                        ForEach(EquipmentOption.allCases) { option in
                            equipmentCard(for: option)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Bottom-anchored Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: !selectedEquipment.isEmpty,
                action: {
                    guard !selectedEquipment.isEmpty else { return }
                    onboarding.answers.equipment = Array(selectedEquipment)
                    onboarding.goToNext()
                }
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Prefill equipment if user navigates back
            if !onboarding.answers.equipment.isEmpty {
                selectedEquipment = Set(onboarding.answers.equipment)
            }
        }
    }
    
    // MARK: - Equipment Card
    
    private func equipmentCard(for option: EquipmentOption) -> some View {
        let isSelected = selectedEquipment.contains(option)
        
        return OnboardingSelectableCard(
            isSelected: isSelected,
            content: {
                HStack(spacing: 12) {
                    // Equipment icon (using SF Symbols)
                    Image(systemName: iconForEquipment(option))
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .secondary)
                        .frame(width: 30, alignment: .center)
                    
                    // Title text
                    Text(option.rawValue)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .primary)
                    
                    Spacer()
                    
                    // Checkmark when selected
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                .frame(height: 60)
            },
            onTap: {
                // Toggle selection with animation
                withAnimation(.easeInOut(duration: 0.15)) {
                    if selectedEquipment.contains(option) {
                        selectedEquipment.remove(option)
                    } else {
                        selectedEquipment.insert(option)
                    }
                }
            }
        )
    }
    
    // MARK: - Icon Helper
    
    private func iconForEquipment(_ option: EquipmentOption) -> String {
        switch option {
        case .fullGym:
            return "building.2.fill"
        case .dumbbells:
            return "dumbbell.fill"
        case .resistanceBands:
            return "bandage.fill"
        case .bodyweight:
            return "figure.strengthtraining.traditional"
        case .kettlebells:
            return "circle.fill"
        case .barbell:
            return "minus"
        case .machines:
            return "gearshape.fill"
        }
    }
}

#Preview {
    OnboardingEquipmentView()
        .environmentObject(OnboardingViewModel.preview)
}
