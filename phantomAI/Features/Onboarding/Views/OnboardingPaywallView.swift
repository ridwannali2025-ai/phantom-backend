//
//  OnboardingPaywallView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingPaywallView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    @EnvironmentObject var appState: AppState

    /// Subscription choice enum
    enum SubscriptionChoice {
        case monthly
        case yearly
    }
    
    // Legacy alias for backward compatibility
    private typealias BillingPlan = SubscriptionChoice

    // MARK: - Pricing configuration (easy to tweak)
    private let monthlyPrice: String = "$9.99"
    private let yearlyPricePerMonth: String = "$4.99"
    private let yearlyPriceTotal: String = "$59.99"

    @State private var selectedPlan: BillingPlan = .monthly

    // MARK: - Body

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header with back button and Restore
                headerSection
                
                // Scrollable content area
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Title
                        titleSection
                            .padding(.top, 24)
                        
                        // Benefits list (immediately under title, no large gap)
                        benefitsSection
                            .padding(.top, 24)
                        
                        // Spacing before pricing cards
                        Spacer(minLength: 20)
                            .frame(height: 20)
                        
                        // Pricing cards row
                        planPickerSection
                        
                        // "No commitment" row (in scrollable area, above button)
                        commitmentRow
                            .padding(.top, 16)
                        
                        // Bottom padding to account for fixed CTA area
                        Spacer(minLength: 120)
                            .frame(height: 120)
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            // Fixed bottom CTA area
            bottomCTASection
        }
    }

    // MARK: - Subviews

    private var headerSection: some View {
        HStack {
            Button(action: { onboarding.goBack() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(hex: "A06AFE"))
                    .padding(8)
            }

            Spacer()

            Button(action: { /* TODO: restore purchases later */ }) {
                Text("Restore")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Color(.systemGray))
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }

    private var titleSection: some View {
        Text("Unlock Phantom to reach your goals faster.")
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.primary)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
    }

    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            BenefitRow(
                title: "Smart AI programming",
                subtitle: "Personalized workouts designed around your goal & schedule."
            )
            BenefitRow(
                title: "Nutrition guidance",
                subtitle: "Smart calorie + macro targets based on your body and training."
            )
            BenefitRow(
                title: "Progress tracking",
                subtitle: "Stay on track with weekly check-ins and habit reminders."
            )
        }
    }

    private var planPickerSection: some View {
        HStack(spacing: 16) {
            PricingCard(
                title: "Monthly",
                priceLine: "\(monthlyPrice) /mo",
                isSelected: selectedPlan == .monthly
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedPlan = .monthly
                }
            }

            PricingCard(
                title: "Yearly",
                priceLine: "\(yearlyPricePerMonth) /mo",
                isSelected: selectedPlan == .yearly
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedPlan = .yearly
                }
            }
        }
    }

    private var commitmentRow: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(hex: "A06AFE"))
                .frame(width: 18, height: 18)

            Text("No commitment – cancel anytime.")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var bottomCTASection: some View {
        VStack(spacing: 8) {
            // Primary button
            Button(action: handlePrimaryCTA) {
                Text("Start My Journey")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(hex: "A06AFE"),
                                Color(hex: "6C4BFF")
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(28)
            }

            // Fine print
            Text("Just \(monthlyPrice) per month. Cancel anytime.")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
        .padding(.bottom, 20)
        .background(
            Color(.systemBackground)
                .ignoresSafeArea(edges: .bottom)
        )
    }

    // MARK: - Actions

    private func handlePrimaryCTA() {
        // Mark subscription as active and onboarding as complete
        appState.hasActiveSubscription = true
        appState.hasCompletedOnboarding = true
        
        // Store subscription choice (could be saved to UserDefaults or backend)
        // For now, we just mark it as active
        
        // Navigate to main app - this will be handled by AppRootView
        // based on appState.currentPhase (will switch to .main)
    }
}

// MARK: - Supporting Views

private struct BenefitRow: View {
    let title: String
    let subtitle: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Circular check icon
            ZStack {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 32, height: 32)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
            }

            // Text content
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

private struct PricingCard: View {
    let title: String
    let priceLine: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .topTrailing) {
                // Card content
                VStack(alignment: .leading, spacing: 8) {
                    Spacer()
                    
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(priceLine)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .frame(height: 150) // Fixed height
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color(.systemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .strokeBorder(
                            isSelected ? Color(hex: "A06AFE") : Color(.systemGray4),
                            lineWidth: 2
                        )
                )
                .shadow(
                    color: isSelected ? Color(hex: "A06AFE").opacity(0.15) : Color.clear,
                    radius: 8,
                    x: 0,
                    y: 4
                )
                
                // Top-right checkmark badge (only when selected)
                if isSelected {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "A06AFE"))
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .offset(x: -10, y: 10)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OnboardingPaywallView()
        .environmentObject(OnboardingViewModel.preview)
        .environmentObject(AppState())
}
