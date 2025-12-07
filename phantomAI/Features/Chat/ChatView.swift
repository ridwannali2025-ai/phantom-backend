//
//  ChatView.swift
//  phantomAI
//
//  Created by Ridwan Ali on 12/1/25.
//

import SwiftUI

/// Chat tab view for AI conversations
struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @StateObject private var postPurchaseVM = PostPurchaseChatViewModel()
    @Environment(\.container) private var container
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var onboarding: OnboardingViewModel
    
    @State private var messages: [ChatMessage] = []
    @State private var userInput: String = ""
    @State private var isWaitingForTextInput: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if postPurchaseVM.phase == .running {
                    // Post-purchase scripted flow
                    postPurchaseChatView
                } else {
                    // Normal chat view
                    switch viewModel.state {
                    case .idle, .loading:
                        ProgressView("Loading chat...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    case .loaded:
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                Text("AI Chat")
                                    .font(.largeTitle)
                                    .bold()
                                    .padding(.horizontal)
                                
                                // TODO: Add chat messages UI
                                Text("Chat messages will appear here")
                                    .padding()
                            }
                        }
                        
                    case .error(let message):
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                            Text("Error")
                                .font(.headline)
                            Text(message)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Button("Retry") {
                                Task {
                                    await viewModel.load(container: container)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .navigationTitle("Chat")
            .task {
                await viewModel.load(container: container)
            }
            .onAppear {
                if appState.shouldShowPostPurchaseChat && postPurchaseVM.phase == .idle {
                    startPostPurchaseFlow()
                }
            }
            .onChange(of: postPurchaseVM.isFinished) { _, isFinished in
                if isFinished {
                    handlePostPurchaseCompletion()
                }
            }
        }
    }
    
    // MARK: - Post-Purchase Chat View
    
    private var postPurchaseChatView: some View {
        VStack(spacing: 0) {
            // Messages scroll view
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(messages) { message in
                        ChatBubble(message: message)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            
            // Current question and input area
            VStack(spacing: 12) {
                if let step = postPurchaseVM.currentStep {
                    // Current question
                    Text(step.question)
                        .font(.body.weight(.semibold))
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                    
                    // Quick reply buttons
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(step.quickReplies, id: \.self) { reply in
                                Button(action: {
                                    handleQuickReply(reply, step: step)
                                }) {
                                    Text(reply)
                                        .font(.system(size: 14, weight: .medium))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color(hex: "A06AFE").opacity(0.1))
                                        )
                                        .foregroundColor(Color(hex: "A06AFE"))
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    // Text input (if user wants to type)
                    if isWaitingForTextInput || step.quickReplies.contains(where: { $0.contains("type") || $0.contains("Type") }) {
                        HStack(spacing: 12) {
                            TextField(step.placeholder ?? "Type your answer...", text: $userInput)
                                .textFieldStyle(.roundedBorder)
                            
                            Button(action: {
                                handleTextInput(step: step)
                            }) {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(userInput.isEmpty ? .gray : Color(hex: "A06AFE"))
                            }
                            .disabled(userInput.isEmpty)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                    }
                }
            }
            .background(Color(.systemBackground))
        }
    }
    
    // MARK: - Chat Bubble
    
    private struct ChatBubble: View {
        let message: ChatMessage
        
        var body: some View {
            HStack {
                if message.isFromUser {
                    Spacer()
                }
                
                VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                    Text(message.content)
                        .font(.body)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(message.isFromUser ? Color(hex: "A06AFE") : Color(.systemGray5))
                        )
                        .foregroundColor(message.isFromUser ? .white : .primary)
                }
                
                if !message.isFromUser {
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Chat Message Model
    
    private struct ChatMessage: Identifiable {
        let id = UUID()
        let content: String
        let isFromUser: Bool
    }
    
    // MARK: - Post-Purchase Flow Handlers
    
    private func startPostPurchaseFlow() {
        postPurchaseVM.start()
        
        // Add welcome message
        let welcomeMessage = ChatMessage(
            content: "Welcome to Phantom. I'm your AI coach. Before I finalize your plan, I have a few quick questions.",
            isFromUser: false
        )
        messages.append(welcomeMessage)
        
        // Add first question after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let step = postPurchaseVM.currentStep {
                let questionMessage = ChatMessage(
                    content: step.question,
                    isFromUser: false
                )
                messages.append(questionMessage)
            }
        }
    }
    
    private func handleQuickReply(_ reply: String, step: PostPurchaseChatStep) {
        // Check if this reply means user wants to type
        if reply.lowercased().contains("type") {
            isWaitingForTextInput = true
            return
        }
        
        // Handle "No, that's it" for optional questions
        if reply.lowercased().contains("no") && reply.lowercased().contains("it") {
            postPurchaseVM.recordAnswer("None")
            addUserMessage(reply)
            addCoachAcknowledgment()
            advanceToNextQuestion()
            return
        }
        
        // Record answer and add messages
        postPurchaseVM.recordAnswer(reply)
        addUserMessage(reply)
        addCoachAcknowledgment()
        advanceToNextQuestion()
    }
    
    private func handleTextInput(step: PostPurchaseChatStep) {
        guard !userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let answer = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        postPurchaseVM.recordAnswer(answer)
        addUserMessage(answer)
        addCoachAcknowledgment()
        userInput = ""
        isWaitingForTextInput = false
        advanceToNextQuestion()
    }
    
    private func addUserMessage(_ content: String) {
        let message = ChatMessage(content: content, isFromUser: true)
        messages.append(message)
    }
    
    private func addCoachAcknowledgment() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let message = ChatMessage(content: "Got it, I'll keep that in mind.", isFromUser: false)
            messages.append(message)
        }
    }
    
    private func advanceToNextQuestion() {
        guard !postPurchaseVM.isFinished else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if let step = postPurchaseVM.currentStep {
                let questionMessage = ChatMessage(
                    content: step.question,
                    isFromUser: false
                )
                messages.append(questionMessage)
            }
        }
    }
    
    private func handlePostPurchaseCompletion() {
        // Add final message
        let finalMessage = ChatMessage(
            content: "Perfect. I've added these notes to your plan and updated your profile.",
            isFromUser: false
        )
        messages.append(finalMessage)
        
        // Complete the flow after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            completePostPurchaseFlow()
        }
    }
    
    private func completePostPurchaseFlow() {
        let notes = postPurchaseVM.finalNotesString()
        if !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            onboarding.answers.coachNotes = notes
        }
        
        // Clear the post-purchase flag so this flow doesn't run again
        appState.completePostPurchaseChat()
        
        // Navigate to the Workouts tab (index 1)
        appState.selectedTab = 1
    }
}

#Preview {
    ChatView()
        .environment(\.container, AppContainer.preview)
}


