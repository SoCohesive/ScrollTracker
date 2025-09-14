//
//  AIAssistantOverlay.swift
//  ScrollTrackerPlayground
//
//  Created by Sonam Dhingra on 9/12/25.
//
import SwiftUI

struct AIAssistantOverlay: View {
    @State private var showAssistant = false
    @State private var currentSuggestion = ""
    @State private var assistantScale: CGFloat = 1.0
    @State private var suggestions = [
        "Take a 5-minute break? You've been scrolling for 15 minutes 🌱",
        "Based on your interests, try switching to educational content 📚",
        "Your focus seems low - time for some fresh air? 🍃",
        "You've watched 12 videos - maybe try a different category? 🎯",
        "Perhaps some sunlight would be nice? ☀️",
        "Time to water your plants (and yourself)? 🌿",
        "Your eyes might need a rest from the screen 👀",
        "Maybe stretch those fingers and legs? 🤸‍♀️",
        "Any dogs around? Maybe show them some love!"
    ]
    @State private var currentSuggestionIndex = 0
    
    init() {

    }
    
    var body: some View {
        VStack {
            Spacer()
            
            // AI Assistant Card
            if showAssistant {
                VStack(spacing: 12) {
                    // AI Icon with pulse
                    HStack {
                        Image("studio_ghibi")
                            .font(.title2)
                            .foregroundColor(.purple)
                            .scaleEffect(assistantScale)
                        
                        Text("AI Assistant")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(.darkGray))
                        
                        Spacer()
                        
                        Button(action: dismissAssistant) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // AI Suggestion
                    Text(currentSuggestion)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 4)
                        .foregroundColor(Color(.darkGray))

                    
                    // Action Buttons
                    HStack(spacing: 12) {
                        Button("Not Now") {
                            dismissAssistant()
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        
                        Button("Good Idea!") {
                            handlePositiveResponse()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.white))
                        .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .scale.combined(with: .opacity)
                ))
            }
            
            // AI Trigger Button (always visible)
            HStack {
                Spacer()
                
                Button(action: toggleAssistant) {

                    Image("sparkles_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .background(
                            Circle()
                                .fill(LinearGradient(
                                    colors: [.purple, .blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .shadow(color: .purple.opacity(0.4), radius: 8, y: 4)
                        )
                        .scaleEffect(showAssistant ? 0.9 : 1.0)
                }
                .padding(.trailing, 20)
            }
            .padding(.bottom, 20)
        }
        .onAppear {
            startPulseAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                triggerAISuggestion()
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func toggleAssistant() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            showAssistant.toggle()
        }
        
        if showAssistant {
            updateSuggestion()
        }
    }
    
    private func dismissAssistant() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            showAssistant = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                toggleAssistant()
            }
        }
    }
    
    private func handlePositiveResponse() {
        // Here you could trigger actual behavior changes
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            showAssistant = false
        }
        
        // Show success feedback
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            toggleAssistant()
        }
    }
    
    private func triggerAISuggestion() {
        updateSuggestion()
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
            showAssistant = true
        }
    }
    
    private func updateSuggestion() {
        currentSuggestion = suggestions[currentSuggestionIndex]
        currentSuggestionIndex = (currentSuggestionIndex + 1) % suggestions.count
    }
    
    private func startPulseAnimation() {
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            assistantScale = 1.1
        }
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(
                        colors: [Color(red: 0.6, green: 0.4, blue: 0.9), Color(red: 0.6, green: 0.4, blue: 0.9)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body)
            .foregroundColor(.secondary)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        AIAssistantOverlay()
    }
}
