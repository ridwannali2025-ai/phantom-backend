import Foundation
import Combine

// MARK: - Scripted post-purchase chat models

struct PostPurchaseChatStep: Identifiable, Equatable {
    let id = UUID()
    let question: String
    let placeholder: String?
    let quickReplies: [String]
    let key: String      // label used when compiling final notes
}

enum PostPurchaseChatPhase {
    case idle
    case running
    case completed
}

// MARK: - ViewModel

final class PostPurchaseChatViewModel: ObservableObject {

    @Published var phase: PostPurchaseChatPhase = .idle
    @Published var currentIndex: Int = 0
    @Published var steps: [PostPurchaseChatStep] = []
    @Published var compiledNotes: [String] = []

    var isFinished: Bool {
        currentIndex >= steps.count
    }
    
    var currentStep: PostPurchaseChatStep? {
        guard currentIndex < steps.count else { return nil }
        return steps[currentIndex]
    }

    init() {
        steps = [
            PostPurchaseChatStep(
                question: "Before we finalize your program, how do you prefer to train?",
                placeholder: nil,
                quickReplies: [
                    "Solo, headphones on",
                    "With a friend or partner",
                    "Busy gyms are fine",
                    "Prefer quiet / less crowded"
                ],
                key: "Training environment"
            ),
            PostPurchaseChatStep(
                question: "Are there any exercises you really dislike or want to avoid?",
                placeholder: "Example: burpees, barbell squats, overhead pressing…",
                quickReplies: [
                    "I'll type them",
                    "Leg-heavy movements",
                    "Upper body pressing",
                    "Cardio-heavy workouts"
                ],
                key: "Exercises to avoid"
            ),
            PostPurchaseChatStep(
                question: "What's the #1 thing you want me to keep in mind as your coach?",
                placeholder: "Example: avoid burnout, time is limited, old injury, etc.",
                quickReplies: [
                    "Time is limited",
                    "I burn out easily",
                    "I'm scared of injury",
                    "I'll type it out"
                ],
                key: "Coach priorities"
            ),
            PostPurchaseChatStep(
                question: "Anything else you want to add before we lock in your program?",
                placeholder: "Optional—add any final notes for your plan.",
                quickReplies: [
                    "No, that's it",
                    "I'll type something"
                ],
                key: "Extra notes"
            )
        ]
    }

    func start() {
        phase = .running
        currentIndex = 0
        compiledNotes = []
    }

    func recordAnswer(_ answer: String) {
        guard currentIndex < steps.count else { return }
        let step = steps[currentIndex]
        let line = "\(step.key): \(answer)"
        compiledNotes.append(line)
        currentIndex += 1

        if currentIndex >= steps.count {
            phase = .completed
        }
    }

    func finalNotesString() -> String {
        compiledNotes.joined(separator: "\n")
    }

    func reset() {
        phase = .idle
        currentIndex = 0
        compiledNotes = []
    }
}
