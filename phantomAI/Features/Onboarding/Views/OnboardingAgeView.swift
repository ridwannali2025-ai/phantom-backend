//
//  OnboardingAgeView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

struct OnboardingAgeView: View {
    @EnvironmentObject var onboarding: OnboardingViewModel
    
    @State private var selectedMonthIndex: Int = 0  // 0-based index into months array
    @State private var selectedDay: Int = 1
    @State private var selectedYear: Int = defaultYear
    
    private static var defaultYear: Int {
        let currentYear = Calendar.current.component(.year, from: Date())
        return currentYear - 24  // Default to 24 years old
    }
    
    private let months = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]
    
    private var currentYear: Int {
        Calendar.current.component(.year, from: Date())
    }
    
    private var yearRange: [Int] {
        let minYear = currentYear - 80
        let maxYear = currentYear - 13
        return Array((minYear...maxYear).reversed())  // Newest year at top
    }
    
    private var daysInSelectedMonth: Int {
        let month = selectedMonthIndex + 1
        let dateComponents = DateComponents(year: selectedYear, month: month, day: 1)
        guard let date = Calendar.current.date(from: dateComponents),
              let range = Calendar.current.range(of: .day, in: .month, for: date) else {
            return 31  // Fallback
        }
        return range.count
    }
    
    private var isValidDOB: Bool {
        guard let age = computeAge(year: selectedYear, month: selectedMonthIndex + 1, day: selectedDay) else {
            return false
        }
        return (13...80).contains(age)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header is already provided by OnboardingFlowView
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Title & subtitle
                    VStack(alignment: .leading, spacing: 8) {
                        Text("When were you born?")
                            .font(.system(size: 32, weight: .bold))
                            .multilineTextAlignment(.leading)
                        
                        Text("This will be used to calibrate your custom plan.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 32)
                    .padding(.horizontal, 24)
                    
                    // Date picker card
                    datePickerCard
                        .padding(.horizontal, 24)
                }
            }
            
            // Bottom-anchored Continue button
            PrimaryContinueButton(
                title: "Continue",
                isEnabled: isValidDOB,
                action: {
                    guard let age = computeAge(
                        year: selectedYear,
                        month: selectedMonthIndex + 1,
                        day: selectedDay
                    ),
                    (13...80).contains(age) else { return }
                    
                    onboarding.answers.age = age
                    onboarding.answers.birthMonth = selectedMonthIndex + 1
                    onboarding.answers.birthDay = selectedDay
                    onboarding.answers.birthYear = selectedYear
                    onboarding.goToNext()
                }
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            // Prefill from existing birth date fields if available
            if let savedMonth = onboarding.answers.birthMonth,
               let savedDay = onboarding.answers.birthDay,
               let savedYear = onboarding.answers.birthYear {
                selectedMonthIndex = savedMonth - 1  // Convert 1-12 to 0-11
                selectedDay = savedDay
                selectedYear = savedYear
            } else if let savedAge = onboarding.answers.age {
                // Fallback: approximate from age
                let approxYear = currentYear - savedAge
                selectedYear = max(currentYear - 80, min(currentYear - 13, approxYear))
                selectedMonthIndex = 0
                selectedDay = 1
            } else {
                // Default to 24 years old
                selectedYear = Self.defaultYear
                selectedMonthIndex = 0
                selectedDay = 1
            }
        }
        .onChange(of: selectedMonthIndex) { _, _ in
            clampDayToValidRange()
        }
        .onChange(of: selectedYear) { _, _ in
            clampDayToValidRange()
        }
    }
    
    // MARK: - Date Picker Card
    
    private var datePickerCard: some View {
        VStack {
            HStack(spacing: 0) {
                // Month picker
                Picker("Month", selection: $selectedMonthIndex) {
                    ForEach(0..<months.count, id: \.self) { index in
                        Text(months[index])
                            .font(.system(size: 20, weight: .medium))
                            .tag(index)
                    }
                }
                .pickerStyle(.wheel)
                .accentColor(Color(hex: "A06AFE"))
                .frame(width: 120, alignment: .center)
                
                // Day picker
                Picker("Day", selection: $selectedDay) {
                    ForEach(1...daysInSelectedMonth, id: \.self) { day in
                        Text("\(day)")
                            .font(.system(size: 20, weight: .medium))
                            .tag(day)
                    }
                }
                .pickerStyle(.wheel)
                .accentColor(Color(hex: "A06AFE"))
                .frame(width: 60, alignment: .center)
                
                // Year picker
                Picker("Year", selection: $selectedYear) {
                    ForEach(yearRange, id: \.self) { year in
                        Text("\(year)")
                            .font(.system(size: 20, weight: .medium))
                            .tag(year)
                    }
                }
                .pickerStyle(.wheel)
                .accentColor(Color(hex: "A06AFE"))
                .frame(width: 90, alignment: .center)
            }
            .frame(maxWidth: .infinity, minHeight: 220)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(.systemGray6))
            )
            .padding(.top, 12)
        }
    }
    
    // MARK: - Helper Functions
    
    private func computeAge(year: Int, month: Int, day: Int) -> Int? {
        let dateComponents = DateComponents(year: year, month: month, day: day)
        guard let birthDate = Calendar.current.date(from: dateComponents) else {
            return nil
        }
        
        let ageComponents = Calendar.current.dateComponents([.year], from: birthDate, to: Date())
        return ageComponents.year
    }
    
    private func clampDayToValidRange() {
        let maxDay = daysInSelectedMonth
        if selectedDay > maxDay {
            selectedDay = maxDay
        }
    }
}

#Preview {
    OnboardingAgeView()
        .environmentObject(OnboardingViewModel.preview)
}
