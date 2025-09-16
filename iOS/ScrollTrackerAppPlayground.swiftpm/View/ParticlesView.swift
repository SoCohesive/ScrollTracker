import SwiftUI

struct LiquidMercuryScrollView: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var progressHeight: CGFloat = 0
    @State private var rippleOffset: CGFloat = 0
    @State private var isScrolling = false
    @State private var lastScrollTime = Date()
    
    // Sample content for demo
    let sampleContent = Array(0..<50).map { "Content Item \($0 + 1)" }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Main scroll content
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(sampleContent, id: \.self) { item in
                            ContentCard(title: item)
                                .background(
                                    GeometryReader { cardGeometry in
                                        Color.clear
                                            .preference(
                                                key: ScrollOffsetPreferenceKey.self,
                                                value: cardGeometry.frame(in: .named("scrollView")).minY
                                            )
                                    }
                                )
                        }
                    }
                    .padding()
                }
                .coordinateSpace(name: "scrollView")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    Task { @MainActor in
                        updateScrollProgress(offset: value, screenHeight: geometry.size.height)
                    }
                }
                
                // Liquid Mercury Progress Bars
                VStack {
                    Spacer()
                    HStack {
                        // Left mercury bar
                        LiquidMercuryBar(
                            height: progressHeight,
                            isScrolling: isScrolling,
                            rippleOffset: rippleOffset,
                            side: .left
                        )
                        
                        Spacer()
                        
                        // Right mercury bar
                        LiquidMercuryBar(
                            height: progressHeight,
                            isScrolling: isScrolling,
                            rippleOffset: rippleOffset,
                            side: .right
                        )
                    }
                }
                .allowsHitTesting(false)
            }
        }
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) {_ in
            checkScrollingState()
        }
    }
    
    private func updateScrollProgress(offset: CGFloat, screenHeight: CGFloat) {
        let newProgress = max(0, min(screenHeight * 0.8, abs(offset) / 10))
        
        withAnimation(.easeOut(duration: 0.3)) {
            progressHeight = newProgress
        }
        
        // Create ripple effect
        withAnimation(.linear(duration: 0.5)) {
            rippleOffset = progressHeight
        }
        
        isScrolling = true
        lastScrollTime = Date()
    }
    
    private func checkScrollingState() {
        if Date().timeIntervalSince(lastScrollTime) > 0.5 {
            withAnimation(.easeOut(duration: 1.0)) {
                isScrolling = false
                progressHeight *= 0.7 // Gentle recession
            }
        }
    }
}

struct LiquidMercuryBar: View {
    let height: CGFloat
    let isScrolling: Bool
    let rippleOffset: CGFloat
    let side: BarSide
    
    @State private var shimmerOffset: CGFloat = -200
    @State private var surfaceTension: CGFloat = 0
    
    enum BarSide {
        case left, right
    }
    
    var body: some View {
        ZStack {
            // Main mercury body
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.7, green: 0.7, blue: 0.8),
                            Color(red: 0.9, green: 0.9, blue: 1.0),
                            Color(red: 0.6, green: 0.6, blue: 0.7)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 6, height: height)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Surface tension effect at top
            if height > 10 {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.8),
                                Color(red: 0.8, green: 0.8, blue: 0.9, opacity: 0.3),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 8
                        )
                    )
                    .frame(width: 12, height: 12)
                    .offset(y: -height/2)
                    .scaleEffect(isScrolling ? 1.2 + surfaceTension : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: isScrolling)
            }
            
            // Shimmer effect
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.6),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 6, height: 20)
                .offset(y: shimmerOffset)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .onAppear {
                    withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                        shimmerOffset = height + 50
                    }
                }
            
            // Ripple effect
            if isScrolling {
                Circle()
                    .stroke(
                        Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.4),
                        lineWidth: 1
                    )
                    .frame(width: 20, height: 20)
                    .offset(y: -height/2 + rippleOffset/10)
                    .scaleEffect(isScrolling ? 1.5 : 0.5)
                    .opacity(isScrolling ? 0.3 : 0)
                    .animation(.easeOut(duration: 0.8), value: isScrolling)
            }
        }
        .onChange(of: height) { _ in
            // Create surface tension variance
            surfaceTension = CGFloat.random(in: -0.1...0.1)
        }
    }
}

struct ContentCard: View {
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("This is sample content for the scroll tracking demo. The liquid mercury bars on the sides will animate as you scroll through this content, creating a mesmerizing and fluid visual feedback.")
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(nil)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    LiquidMercuryScrollView()
}
