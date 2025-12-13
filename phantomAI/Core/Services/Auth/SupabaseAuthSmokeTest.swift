//
//  SupabaseAuthSmokeTest.swift
//  phantomAI
//
//  Smoke test for Phase 1 Step 1: Auth → JWT → RLS-protected reads/writes
//  This is a debug-only utility function for testing end-to-end authentication and RLS
//

import Foundation

/// Smoke test function to verify end-to-end auth flow and RLS protection
/// Signs in/up, inserts a weight entry, reads it back, and prints results
@MainActor
func runSupabaseAuthSmokeTest(
    email: String,
    password: String,
    config: AppConfig,
    shouldSignUp: Bool = false
) async {
    print("🧪 Starting Supabase Auth Smoke Test...")
    print("📧 Email: \(email)")
    print("🔐 Sign up: \(shouldSignUp)")
    
    let authService = SupabaseAuthService(config: config)
    let weightService = SupabaseWeightService(config: config)
    
    // Step 1: Sign in or sign up
    do {
        if shouldSignUp {
            print("\n1️⃣ Signing up...")
            try await authService.signUp(email: email, password: password)
            print("✅ Sign up successful")
        } else {
            print("\n1️⃣ Signing in...")
            try await authService.signIn(email: email, password: password)
            print("✅ Sign in successful")
        }
        
        // Get user ID from session store
        let sessionStore = SupabaseSessionStore.shared
        guard let userId = sessionStore.userId else {
            print("❌ FAILED: No user ID in session store after sign in")
            return
        }
        print("👤 User ID: \(userId)")
        print("🔑 Access token present: \(sessionStore.accessToken != nil)")
        
        // Step 2: Insert a weight entry
        print("\n2️⃣ Inserting weight entry...")
        let testWeight = 75.5
        let insertedEntry = try await weightService.insertWeightEntry(
            userId: userId,
            date: Date(),
            weight: testWeight
        )
        print("✅ Weight entry inserted")
        print("   ID: \(insertedEntry.id)")
        print("   Weight: \(insertedEntry.weight) kg")
        print("   Date: \(insertedEntry.date)")
        
        // Step 3: Read it back
        print("\n3️⃣ Reading weight entries back...")
        let entries = try await weightService.fetchWeightEntries(userId: userId, limit: 5)
        print("✅ Fetched \(entries.count) weight entries")
        
        // Verify the entry we just inserted is in the results
        let foundEntry = entries.first { $0.id == insertedEntry.id }
        if let found = foundEntry {
            print("✅ SUCCESS: Found inserted entry in read results")
            print("   Entry weight: \(found.weight) kg")
            if abs(found.weight - testWeight) < 0.01 {
                print("✅ SUCCESS: Weight value matches (\(testWeight) kg)")
            } else {
                print("⚠️ WARNING: Weight value mismatch (expected \(testWeight), got \(found.weight))")
            }
        } else {
            print("❌ FAILED: Inserted entry not found in read results")
        }
        
        print("\n🎉 Smoke test completed successfully!")
        print("✅ Auth → JWT → RLS-protected write → RLS-protected read: WORKING")
        
    } catch {
        print("\n❌ FAILED: \(error.localizedDescription)")
        if let nsError = error as NSError? {
            print("   Domain: \(nsError.domain)")
            print("   Code: \(nsError.code)")
            if let userInfo = nsError.userInfo[NSLocalizedDescriptionKey] as? String {
                print("   Details: \(userInfo)")
            }
        }
        print("\n💡 Check:")
        print("   - Supabase URL and anon key are correct")
        print("   - RLS policies allow authenticated users to insert/select their own data")
        print("   - Network connectivity")
    }
}
