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
    @State private var randomTimer: Timer?
    @State private var showBreatheExperience = false
    @State private var breatheScale: CGFloat = 1.0
    @State private var breatheOpacity: Double = 0.0
    @State private var backgroundColorIntensity: Double = 0.0
    @State private var floatingParticles: [FloatingParticle] = []
    @State private var sparkleOpacity: Double = 0.0
    
    @State private var suggestions = [
        "How about a quick rest for your eyes?",
        "Based on your interests, try switching to educational content 📚",
        "Your focus seems low - time for some fresh air? 🍃",
        "You've watched 12 videos - maybe try a different category? 🎯",
        "Perhaps some sunlight would be nice? ☀️",
        "Time to water your plants?!🌿",
        "Your eyes might need a rest from the screen 👀",
        "Maybe stretch those fingers and legs? 🤸‍♀️",
        "Any dogs around? Maybe show them some love!"
    ]
    @State private var currentSuggestionIndex = 0
    
    var body: some View {
        ZStack {
            // Magical background overlay for breathe experience
            if showBreatheExperience {
                Rectangle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.purple.opacity(0.3 * backgroundColorIntensity),
                                Color(red: 0.8, green: 0.6, blue: 1.0).opacity(0.4 * backgroundColorIntensity),
                                Color(red: 0.9, green: 0.7, blue: 1.0).opacity(0.2 * backgroundColorIntensity)
                            ],
                            center: .center,
                            startRadius: 50,
                            endRadius: 500
                        )
                    )
                    .ignoresSafeArea()
                    .opacity(breatheOpacity)
                
                // Floating magical particles
                ForEach(floatingParticles, id: \.id) { particle in
                    Circle()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: particle.size, height: particle.size)
                        .position(x: particle.x, y: particle.y)
                        .opacity(sparkleOpacity)
                }
                
                // Breathe text
                VStack(spacing: 20) {
                    Text("✨")
                        .font(.system(size: 40))
                        .scaleEffect(breatheScale)
                        .opacity(breatheOpacity)
                    
                    Text("Breathe")
                        .font(.largeTitle)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .scaleEffect(breatheScale)
                        .opacity(breatheOpacity)
                    
                    Text("Take a moment for yourself")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                        .opacity(breatheOpacity)
                }
            }
            
            // Small AI assistant indicator when not expanded
            if !showBreatheExperience {
                VStack {
                    Spacer()
                    
                    HStack {
                        // Subtle vertical assistant indicator on far left
                        if !showAssistant {
                            Button(action: {
                                triggerAISuggestion()
                            }) {
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.8, green: 0.7, blue: 1.0).opacity(0.6),
                                                Color(red: 0.6, green: 0.4, blue: 0.9).opacity(0.4)
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(width: 3, height: 40)
                                    .cornerRadius(2)
                                    .shadow(color: .purple.opacity(0.2), radius: 3, y: 1)
                                    .scaleEffect(assistantScale)
                            }
                            .padding(.leading, 8)
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                
                // Expanded AI Assistant Card - positioned higher
                if showAssistant {
                    VStack {
                        Spacer()

                        VStack(alignment: .leading, spacing: 16) {   // 👈 left-align stack
                            // Header
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(alignment: .firstTextBaseline) {
                                    Text("Mindful Moment")
                                        .font(.title3.weight(.medium))
                                        .foregroundColor(.primary)

                                    Spacer()

                                    Button(action: dismissAssistant) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray.opacity(0.7))
                                            .font(.title3)
                                    }
                                    .buttonStyle(.plain)
                                }

                                // Animated divider
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.clear,
                                                     Color.purple.opacity(0.3),
                                                     Color.clear],
                                            startPoint: .leading, endPoint: .trailing
                                        )
                                    )
                                    .frame(height: 1)
                                    .scaleEffect(x: assistantScale, y: 1.0, anchor: .center)
                            }

                            // Suggestion text (left aligned across full width)
                            Text(currentSuggestion)
                                .font(.body)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)   // 👈 left align

                            // Action buttons: equal width + less horizontal padding
                            HStack(spacing: 12) {
                                  Button("Not Now") { dismissAssistant() }
                                      .buttonStyle(EnhancedSecondaryButtonStyle())
                                      .frame(maxWidth: .infinity, alignment: .leading)   // ⬅️ equal width + left edge

                                  Button("Good Idea!") { handleMagicalResponse() }
                                      .buttonStyle(MagicalButtonStyle())
                                      .frame(maxWidth: .infinity, alignment: .leading)   // ⬅️ equal width + left edge
                              }
                          }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color.purple.opacity(0.3),
                                                    Color.blue.opacity(0.2),
                                                    Color.purple.opacity(0.3)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                                .shadow(color: .purple.opacity(0.1), radius: 20, y: 10)
                        )
                        .padding(.horizontal, 20)
                        .padding(.vertical, 110)
                        .scaleEffect(showAssistant ? 1.0 : 0.8)
                        .opacity(showAssistant ? 1.0 : 0.0)
                    }
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
                }

            }
        }
        .onAppear {
            startPulseAnimation()
            startRandomAppearances()
            generateFloatingParticles()
        }
        .onDisappear {
            stopRandomAppearances()
        }
    }
    
    // MARK: - Magical Response Handler
    
    private func handleMagicalResponse() {
        withAnimation(.easeInOut(duration: 0.6)) {
            showAssistant = false
            showBreatheExperience = true
        }
        
        // Animate background colors
        withAnimation(.easeInOut(duration: 1.3)) {
            backgroundColorIntensity = 1.0
            breatheOpacity = 1.0
        }
        
        // Start breathing animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            startBreatheAnimation()
        }
        
        // Show particles
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 1.5)) {
                sparkleOpacity = 1.0
            }
        }
        
        // End breathe experience
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            endBreatheExperience()
        }
    }
    
    private func startBreatheAnimation() {
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            breatheScale = 1.1
        }
    }
    
    private func endBreatheExperience() {
        withAnimation(.easeOut(duration: 1.5)) {
            breatheOpacity = 0.0
            sparkleOpacity = 0.0
            backgroundColorIntensity = 0.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showBreatheExperience = false
            breatheScale = 1.0
            scheduleNextRandomAppearance()
        }
    }
    
    private func generateFloatingParticles() {
        floatingParticles = (0..<20).map { _ in
            FloatingParticle(
                id: UUID(),
                x: CGFloat.random(in: 50...350),
                y: CGFloat.random(in: 100...700),
                size: CGFloat.random(in: 2...8)
            )
        }
    }
    
    // MARK: - Helper Functions
    
    private func dismissAssistant() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            showAssistant = false
        }
        scheduleNextRandomAppearance()
    }
    
    private func triggerAISuggestion() {
        updateSuggestion()
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            showAssistant = true
        }
    }
    
    private func updateSuggestion() {
        currentSuggestion = suggestions[currentSuggestionIndex]
        currentSuggestionIndex = (currentSuggestionIndex + 1) % suggestions.count
    }
    
    private func startPulseAnimation() {
        withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
            assistantScale = 1.05
        }
    }
    
    private func startRandomAppearances() {
        scheduleNextRandomAppearance()
    }
    
    private func scheduleNextRandomAppearance() {
        stopRandomAppearances()
        let randomInterval = Double.random(in: 3.0...10.0)
        
        randomTimer = Timer.scheduledTimer(withTimeInterval: randomInterval, repeats: false) { _ in
            DispatchQueue.main.async {
                if !showAssistant && !showBreatheExperience {
                    triggerAISuggestion()
                }
            }
        }
    }
    
    private func stopRandomAppearances() {
        randomTimer?.invalidate()
        randomTimer = nil
    }
}

// MARK: - Supporting Structures

struct FloatingParticle {
    let id: UUID
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
}

// MARK: - Enhanced Button Styles

struct MagicalButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.8, green: 0.6, blue: 1.0),
                                Color(red: 0.6, green: 0.4, blue: 0.9)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .purple.opacity(0.3), radius: 8, y: 4)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}

struct EnhancedSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body)
            .foregroundColor(.secondary)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6).opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4).opacity(0.5), lineWidth: 0.5)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        LinearGradient(
            colors: [Color.black, Color.gray.opacity(0.8)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        
        AIAssistantOverlay()
    }
}
