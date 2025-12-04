# 🔍 ONBOARDING SYSTEM AUDIT REPORT
**Generated:** December 2025  
**Project:** phantomAI

---

## 1. UI SCREENS AUDIT

### ✅ COMPLETE UI (5 screens)
These screens have full UI implementation with proper styling, validation, and user interaction:

1. **OnboardingPrimaryGoalView.swift** - Visual pill selector with icons
2. **OnboardingGoalTimelineView.swift** - Slider-based timeline selector
3. **OnboardingBodyStatsView.swift** - Height picker with Imperial/Metric toggle
4. **OnboardingWeightView.swift** - Weight picker with unit conversion
5. **OnboardingAgeView.swift** - Age scroll wheel picker
6. **OnboardingSexView.swift** - Three pill-style cards (Male, Female, Other)
7. **OnboardingActivityLevelView.swift** - Four icon cards for activity levels

### ⚠️ PARTIAL UI (16 screens)
These screens exist but are placeholder implementations with minimal UI:

1. **OnboardingWelcomeView.swift** - Placeholder text only
2. **OnboardingWorkoutTimeView.swift** - Placeholder text only
3. **OnboardingSleepView.swift** - Placeholder text only
4. **OnboardingPastBlockersView.swift** - Placeholder text only
5. **OnboardingEquipmentView.swift** - Placeholder text only
6. **OnboardingTrainingDaysView.swift** - Placeholder text only
7. **OnboardingSplitPreferenceView.swift** - Placeholder text only
8. **OnboardingSessionLengthView.swift** - Placeholder text only
9. **OnboardingExperienceView.swift** - Placeholder text only
10. **OnboardingBenchmarkView.swift** - Placeholder text only
11. **OnboardingInjuriesView.swift** - Placeholder text only
12. **OnboardingDietNeedsView.swift** - Placeholder text only
13. **OnboardingCookingSkillView.swift** - Placeholder text only
14. **OnboardingRecentIntakeView.swift** - Placeholder text only
15. **OnboardingFoodAversionsView.swift** - Placeholder text only
16. **OnboardingCoachStyleView.swift** - Placeholder text only

### ✅ SPECIAL SCREENS (3 screens)
1. **OnboardingAIAnalysisView.swift** - Placeholder (should show ProgramBuildingView)
2. **OnboardingPlanSummaryView.swift** - Placeholder (should show final summary)
3. **ProgramBuildingView.swift** - ✅ COMPLETE - Animated loading screen with progress steps

### ❌ MISSING SCREENS
None - all steps have corresponding view files, but many are placeholders.

### 🔄 DUPLICATED/INCONSISTENT
- **OnboardingGoalView.swift** exists but is NOT used in flow (duplicate of OnboardingPrimaryGoalView?)
- **OnboardingScheduleView.swift** exists but is NOT in OnboardingStep enum

---

## 2. NAVIGATION AUDIT

### ✅ OnboardingFlowView.swift
**Status:** EXISTS and properly structured

**Location:** `phantomAI/phantomAI/Features/Onboarding/OnboardingFlowView.swift`

**Structure:**
- Uses `@StateObject var viewModel: OnboardingViewModel`
- Switch statement routing all 23 steps
- OnboardingHeaderView included at top

### ✅ ALL STEPS ROUTED
All 23 steps from `OnboardingStep` enum are routed in the switch statement.

### ⚠️ INCONSISTENT INJECTION PATTERNS
**Problem:** Mixed usage of `@ObservedObject` vs `@EnvironmentObject`

**Using @EnvironmentObject (5 screens):**
- OnboardingBodyStatsView
- OnboardingWeightView
- OnboardingAgeView
- OnboardingSexView
- OnboardingActivityLevelView

**Using @ObservedObject (18 screens):**
- All other screens use `@ObservedObject var viewModel: OnboardingViewModel`

**Issue:** This inconsistency means some screens can't access `onboarding.answers` directly.

### ❌ MISSING ROUTES
- `ProgramBuildingView` is NOT in the flow switch statement
- Should be shown at `.aiAnalysis` step but currently shows `OnboardingAIAnalysisView` (placeholder)

---

## 3. VIEWMODEL AUDIT

### ✅ OnboardingViewModel.swift EXISTS
**Location:** `phantomAI/phantomAI/Core/Onboarding/OnboardingViewModel.swift`

### ✅ REQUIRED PROPERTIES
- ✅ `@Published var currentStep: OnboardingStep = .welcome`
- ✅ `@Published var answers = OnboardingAnswers()`
- ✅ `func goToNext()` - exists
- ✅ `func goBack()` - exists
- ✅ `func goNext()` - legacy alias (backward compatibility)

### ⚠️ DUPLICATE STATE PROPERTIES
**CRITICAL ISSUE:** ViewModel has duplicate `@Published` properties that should be in `answers` only:

**Duplicates in ViewModel:**
- `@Published var primaryGoal: PrimaryGoal?` (should use `answers.primaryGoal`)
- `@Published var goalTimeline: GoalTimeline?` (should use `answers.goalTimeline`)
- `@Published var heightFeet: Int?` (legacy, not needed)
- `@Published var heightInches: Int?` (legacy, not needed)
- `@Published var heightCm: Int?` (legacy, not needed)
- `@Published var isImperialUnits: Bool` (legacy, not needed)
- `@Published var weightLbs: Int?` (legacy, not needed)
- `@Published var weightKg: Int?` (legacy, not needed)
- `@Published var age: Int?` (should use `answers.age`)
- `@Published var sex: SexType?` (should use `answers.sex`)
- `@Published var activityLevel: ActivityLevel?` (should use `answers.activityLevel`)

**Problem:** These create confusion and potential data sync issues. Views should write directly to `answers.*` properties.

### ✅ NO DUPLICATE VIEWMODELS
Only one OnboardingViewModel exists in the codebase.

### ❌ MISSING FUNCTIONALITY
- ❌ No method to convert `OnboardingAnswers` → `UserProfile` for AI service
- ❌ No method to save `answers` to backend
- ❌ No method to persist `answers` locally
- ❌ No method to load saved onboarding state on app launch
- ❌ No validation that required fields are filled before proceeding

---

## 4. DATA MODEL AUDIT

### ✅ OnboardingAnswers.swift EXISTS
**Location:** `phantomAI/phantomAI/Core/Models/OnboardingAnswers.swift`

### ✅ EXISTING FIELDS (Correctly Named)
1. `primaryGoal: PrimaryGoal?` ✅
2. `goalTimeline: GoalTimeline?` ✅
3. `commitmentScore: Int?` ✅
4. `pastBarriers: [PastBarrier]` ✅
5. `heightCm: Double?` ✅
6. `weightKg: Double?` ✅
7. `age: Int?` ✅
8. `sex: SexType?` ✅
9. `activityLevel: ActivityLevel?` ✅
10. `sleepHours: Double?` ✅
11. `workoutTime: WorkoutTime?` ✅
12. `equipment: [EquipmentOption]` ✅
13. `trainingDaysPerWeek: Int?` ✅
14. `trainingExperience: TrainingExperience?` ✅
15. `hasInjuries: Bool?` ✅
16. `injuryDetails: String?` ✅
17. `dietaryRestrictions: [DietaryRestriction]` ✅
18. `avoidFoods: String?` ✅
19. `cookingComfort: CookingComfort?` ✅
20. `coachStyle: CoachStyle?` ✅

### ✅ ENUMS EXIST
- ✅ `PrimaryGoal` - 5 cases (buildMuscle, loseFat, getStronger, improveEndurance, generalFitness)
- ✅ `GoalTimeline` - 3 cases (aggressive, moderate, sustainable)
- ✅ `PastBarrier` - 6 cases
- ✅ `SexType` - 3 cases (other, male, female)
- ✅ `ActivityLevel` - 4 cases (mostlySitting, sometimesOnFeet, oftenOnFeet, veryActive)
- ✅ `WorkoutTime` - 4 cases (morning, lunch, evening, flexible)
- ✅ `EquipmentOption` - 7 cases
- ✅ `TrainingExperience` - 3 cases (beginner, intermediate, advanced)
- ✅ `DietaryRestriction` - 8 cases
- ✅ `CookingComfort` - 4 cases
- ✅ `CoachStyle` - 3 cases (supportive, challenging, balanced)

### ❌ MISSING ENUMS
- ❌ `TrainingSplit` - NOT FOUND (referenced by `splitPreference` step but enum doesn't exist)
- ❌ `FitnessBenchmark` - NOT FOUND (referenced by `fitnessBenchmark` step but enum doesn't exist)

### ⚠️ INCONSISTENT NAMING
- `BiologicalSex` exists but is LEGACY (should use `SexType`)
- `FitnessGoal` exists but is LEGACY (should use `PrimaryGoal`)

---

## 5. SCREEN ↔ DATA WIRING AUDIT

### ✅ FULLY WIRED (5 screens)
These screens write to `onboarding.answers.*` and call `onboarding.goToNext()`:

1. **OnboardingBodyStatsView** ✅
   - Writes: `onboarding.answers.heightCm`
   - Calls: `onboarding.goToNext()`

2. **OnboardingWeightView** ✅
   - Writes: `onboarding.answers.weightKg`
   - Calls: `onboarding.goToNext()`

3. **OnboardingAgeView** ✅
   - Writes: `onboarding.answers.age`
   - Calls: `onboarding.goToNext()`

4. **OnboardingSexView** ✅
   - Writes: `onboarding.answers.sex`
   - Calls: `onboarding.goToNext()`

5. **OnboardingActivityLevelView** ✅
   - Writes: `onboarding.answers.activityLevel`
   - Calls: `onboarding.goToNext()`

### ⚠️ PARTIALLY WIRED (2 screens)
These screens update ViewModel properties but DON'T write to `answers`:

1. **OnboardingPrimaryGoalView** ⚠️
   - Updates: `viewModel.primaryGoal` (NOT `answers.primaryGoal`)
   - Calls: `viewModel.goNext()`
   - **MISSING:** Should write to `onboarding.answers.primaryGoal`

2. **OnboardingGoalTimelineView** ⚠️
   - Updates: `viewModel.weeklyFatLoss` and `viewModel.goalTimeline` (NOT `answers.goalTimeline`)
   - Calls: `viewModel.goNext()`
   - **MISSING:** Should write to `onboarding.answers.goalTimeline`

### ❌ NOT WIRED (16 screens)
These screens are placeholders with NO data wiring:

1. OnboardingWelcomeView - Only calls `viewModel.goNext()`
2. OnboardingWorkoutTimeView - Only calls `viewModel.goNext()`
3. OnboardingSleepView - Only calls `viewModel.goNext()`
4. OnboardingPastBlockersView - Only calls `viewModel.goNext()`
5. OnboardingEquipmentView - Only calls `viewModel.goNext()`
6. OnboardingTrainingDaysView - Only calls `viewModel.goNext()`
7. OnboardingSplitPreferenceView - Only calls `viewModel.goNext()`
8. OnboardingSessionLengthView - Only calls `viewModel.goNext()`
9. OnboardingExperienceView - Only calls `viewModel.goNext()`
10. OnboardingBenchmarkView - Only calls `viewModel.goNext()`
11. OnboardingInjuriesView - Only calls `viewModel.goNext()`
12. OnboardingDietNeedsView - Only calls `viewModel.goNext()`
13. OnboardingCookingSkillView - Only calls `viewModel.goNext()`
14. OnboardingRecentIntakeView - Only calls `viewModel.goNext()`
15. OnboardingFoodAversionsView - Only calls `viewModel.goNext()`
16. OnboardingCoachStyleView - Only calls `viewModel.goNext()`

**All of these need:**
- UI implementation
- Local `@State` for user selection
- Write to `onboarding.answers.*` on Continue
- Call `onboarding.goToNext()`

---

## 6. MISSING FUNCTIONAL LAYERS

### ⚠️ AI ProgramRequest Builder
**Status:** PARTIALLY EXISTS

**Found:**
- `AIService` protocol exists (`Core/Services/AI/AIService.swift`)
- `VercelAIService` exists but NOT IMPLEMENTED (throws "Not implemented" error)
- `MockAIService` exists for development

**Missing:**
- ❌ No function to convert `OnboardingAnswers` → `UserProfile`
- ❌ No function to convert `OnboardingAnswers` → API request payload
- ❌ `VercelAIService.buildProgram()` is a stub (throws error)

### ⚠️ AI Call Service
**Status:** EXISTS but NOT IMPLEMENTED

**Found:**
- `VercelAIService.swift` has method signatures
- Both `buildProgram()` and `chat()` methods throw "Not implemented" errors

**Missing:**
- ❌ Actual HTTP request implementation
- ❌ Request/response encoding/decoding
- ❌ Error handling

### ❌ Saving Onboarding Answers to Backend
**Status:** NOT FOUND

**Missing:**
- ❌ No service to save `OnboardingAnswers` to Supabase/backend
- ❌ No API endpoint integration
- ❌ No sync mechanism

### ⚠️ Persisting Onboarding Completion State
**Status:** PARTIALLY EXISTS

**Found:**
- `LocalStorageService` protocol exists
- `UserDefaultsLocalStorageService` exists with:
  - `setOnboardingCompleted(_ completed: Bool)`
  - `isOnboardingCompleted() -> Bool`

**Missing:**
- ❌ No code that actually CALLS `setOnboardingCompleted(true)` when onboarding finishes
- ❌ No code that saves `OnboardingAnswers` to UserDefaults/disk

### ❌ Loading Onboarding State on App Launch
**Status:** NOT FOUND

**Missing:**
- ❌ No code to check `isOnboardingCompleted()` on app launch
- ❌ No code to route to onboarding if not completed
- ❌ No code to restore partial onboarding progress

### ✅ Program Building Animated Screen
**Status:** EXISTS and COMPLETE

**Found:**
- `ProgramBuildingView.swift` exists
- Has animated loading steps
- Has `onFinished` callback

**Issue:**
- ❌ NOT wired into `OnboardingFlowView` switch statement
- Should be shown at `.aiAnalysis` step

### ⚠️ "Your Plan is Ready" Summary Screen
**Status:** EXISTS but PLACEHOLDER

**Found:**
- `OnboardingPlanSummaryView.swift` exists
- Currently just placeholder text
- Routed at `.planSummary` step

**Missing:**
- ❌ No UI to display generated program summary
- ❌ No integration with Program model
- ❌ No "Start Training" button to exit onboarding

---

## 7. PROJECT HEALTH SUMMARY

### ✅ WHAT IS GOOD

1. **Solid Foundation:**
   - Clean architecture with separation of concerns
   - `OnboardingAnswers` struct is well-designed
   - All enums are properly defined
   - Navigation flow is complete (all 23 steps routed)

2. **Recent Improvements:**
   - 5 screens fully wired with `@EnvironmentObject` pattern
   - These screens properly save to `onboarding.answers.*`
   - `ProgramBuildingView` is beautifully implemented

3. **Design System:**
   - `OnboardingHeaderView` provides consistent header
   - `OnboardingSelectableCard` is reusable
   - `PrimaryContinueButton` provides consistent CTA

### ⚠️ WHAT NEEDS ATTENTION

1. **Data Wiring Inconsistency:**
   - Only 5 of 23 screens write to `onboarding.answers`
   - `OnboardingPrimaryGoalView` and `OnboardingGoalTimelineView` write to ViewModel properties instead of `answers`
   - 16 screens are placeholders with no wiring

2. **Duplicate State:**
   - ViewModel has duplicate `@Published` properties that mirror `answers`
   - This creates confusion and potential sync issues
   - Should be removed in favor of direct `answers.*` access

3. **Inconsistent Injection:**
   - Mix of `@ObservedObject` and `@EnvironmentObject`
   - Should standardize on `@EnvironmentObject` for consistency

4. **Missing Enums:**
   - `TrainingSplit` enum doesn't exist (needed for `splitPreference`)
   - `FitnessBenchmark` enum doesn't exist (needed for `fitnessBenchmark`)

### ❌ WHAT IS MISSING

1. **Backend Integration:**
   - No code to save `OnboardingAnswers` to Supabase
   - No code to sync onboarding completion state

2. **AI Integration:**
   - `VercelAIService` is not implemented (stub only)
   - No conversion from `OnboardingAnswers` → `UserProfile`
   - No actual API calls

3. **Persistence:**
   - No code to save `OnboardingAnswers` to disk
   - No code to restore partial progress
   - `setOnboardingCompleted()` exists but is never called

4. **App Launch Logic:**
   - No code to check onboarding completion on launch
   - No routing logic to show onboarding if incomplete

5. **UI Implementation:**
   - 16 screens are placeholders
   - `OnboardingPlanSummaryView` needs full implementation

### 🔄 WHAT IS DUPLICATED

1. **OnboardingGoalView.swift** - File exists but is NOT used (duplicate of OnboardingPrimaryGoalView?)

2. **ViewModel Properties** - Duplicate `@Published` properties that mirror `answers.*`

3. **Legacy Enums:**
   - `BiologicalSex` (should use `SexType`)
   - `FitnessGoal` (should use `PrimaryGoal`)

---

## 8. NEXT 5 STEPS (IN ORDER)

### STEP 1: Fix Data Wiring for Completed Screens
**Priority:** CRITICAL  
**Files to Update:**
- `OnboardingPrimaryGoalView.swift` - Write to `onboarding.answers.primaryGoal`
- `OnboardingGoalTimelineView.swift` - Write to `onboarding.answers.goalTimeline`

**Action:**
- Change both to use `@EnvironmentObject var onboarding: OnboardingViewModel`
- Remove references to `viewModel.primaryGoal` and `viewModel.goalTimeline`
- Write directly to `onboarding.answers.primaryGoal` and `onboarding.answers.goalTimeline`

### STEP 2: Remove Duplicate ViewModel Properties
**Priority:** HIGH  
**File to Update:**
- `OnboardingViewModel.swift`

**Action:**
- Remove all duplicate `@Published` properties:
  - `primaryGoal`, `goalTimeline`, `heightFeet`, `heightInches`, `heightCm`, `isImperialUnits`, `weightLbs`, `weightKg`, `age`, `sex`, `activityLevel`
- Keep only: `currentStep`, `answers`, `weeklyFatLoss` (needed for slider logic)
- Update any remaining views that reference these properties

### STEP 3: Standardize on @EnvironmentObject
**Priority:** HIGH  
**Files to Update:**
- All 18 views using `@ObservedObject`

**Action:**
- Change all to `@EnvironmentObject var onboarding: OnboardingViewModel`
- Update `OnboardingFlowView` to use `.environmentObject(viewModel)` for all cases
- Remove `viewModel:` parameter from all view initializers

### STEP 4: Create Missing Enums
**Priority:** MEDIUM  
**File to Update:**
- `OnboardingAnswers.swift`

**Action:**
- Create `TrainingSplit` enum (cases: fullBody, upperLower, pushPullLegs, etc.)
- Create `FitnessBenchmark` enum (cases: beginner, intermediate, advanced, etc.)
- Add `splitPreference: TrainingSplit?` to `OnboardingAnswers`
- Add `fitnessBenchmark: FitnessBenchmark?` to `OnboardingAnswers`

### STEP 5: Wire ProgramBuildingView into Flow
**Priority:** MEDIUM  
**Files to Update:**
- `OnboardingFlowView.swift`

**Action:**
- Replace `OnboardingAIAnalysisView` with `ProgramBuildingView` in `.aiAnalysis` case
- Pass callback to `ProgramBuildingView` that:
  1. Calls AI service to build program
  2. Saves program to backend
  3. Sets `onboardingCompleted = true`
  4. Navigates to main app

---

## 9. ADDITIONAL RECOMMENDATIONS

### Short Term (Next Sprint)
- Implement remaining 16 placeholder screens
- Add validation before allowing `goToNext()` on each screen
- Create `OnboardingAnswers` → `UserProfile` converter function

### Medium Term (Next Month)
- Implement `VercelAIService.buildProgram()` with actual API calls
- Add persistence layer for `OnboardingAnswers` (save to UserDefaults)
- Add app launch logic to check onboarding completion

### Long Term (Next Quarter)
- Add ability to resume partial onboarding
- Add analytics tracking for onboarding completion rates
- Add A/B testing for onboarding flow variations

---

**END OF AUDIT REPORT**

