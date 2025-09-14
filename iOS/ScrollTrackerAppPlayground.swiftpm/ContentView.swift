import SwiftUI
import WebKit
import AVKit


struct ContentView: View {
    var body: some View {
        ZStack {
            TestScrollView()
        }
    }
}


struct TestScrollView: View {
    
    @State private var scrollID: Int?
    @State private var scrolledFraction = CGFloat.zero
    @State private var show = false
    @State private var showToast = false
    @State private var selectedScrollTrackerType =  ScrollTrackerTypeToggle.ScrollTrackerType.aiAssistant
    private let nProgressBars = 10
    
    
    let videoNames = ["zachking_hogwarts","fortnite_one", "catmeow3694_cats", "dubai_chocolate", "colbyirv_bunnies", "dailymailuk_cheese", "dog_one","linmeimeiyyds_car", "dubai_chocolate", "colbyirv_bunnies", "dailymailuk_cheese", "dog_one","linmeimeiyyds_car"]
    
    
    private func opacityForBar(n: Int) -> CGFloat {
        let result: CGFloat
        let progress = scrolledFraction * CGFloat(nProgressBars)
        print(progress)
        let nFullBars = Int(progress)
        if n < nFullBars {
            result = 1
        } else if n == nFullBars {
            result = progress - CGFloat(nFullBars)
        } else {
            result = 0
        }
        return result
    }
    
    
    private func scrollDetector(screenHeight: CGFloat) -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .scrollView).minY
            Color.green
                .onChange(of: minY) { oldVal, newVal in
                    scrolledFraction = -minY / (proxy.size.height - screenHeight)
                }
        }
    }
    
    static func redForIndex(_ index: Int, maxIndex: Int) -> Color {
        // Scale brightness from 0.3 (dull/dark red) to 1.0 (full bright red)
        let fraction = Double(index) / Double(maxIndex)
        let brightness = 0.7 + (fraction * 0.8)
        return Color(hue: 0.0, saturation: 1.0, brightness: brightness)
    }
    
    
    var body: some View {
        GeometryReader { outer in
            ZStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(videoNames.enumerated()), id: \.offset) { index, name in
                            LocalVideoPlayerView(videoName: name)
                                .containerRelativeFrame(.vertical)
                                .ignoresSafeArea()
                                .onAppear {
                                    if index == 4 && !showToast {
                                        withAnimation(.spring(response: 1.2, dampingFraction: 0.7)) {
                                            showToast = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                                withAnimation(.spring(response: 1.2, dampingFraction: 0.7)) {
                                                    showToast = false
                                                }
                                            }
                                        }
                                    }
                                }
                        }
                    }
                    .scrollPosition(id: $scrollID)
                    .background(scrollDetector(screenHeight: outer.size.height))
                }
                .ignoresSafeArea()
                .scrollTargetBehavior(.paging)
                .overlay(alignment: .bottom) {
                    if showToast && selectedScrollTrackerType == .bottomToast {
                        BottomToastView(message: "Oh! Perhaps, its time to take a break")
                    }
                }.overlay(alignment: .bottom) {
                    
                    // FIXED CONTENT HERE (progress bars)
                    if selectedScrollTrackerType == .redBars {
                        HStack(alignment: .bottom) {
                            ForEach(0..<nProgressBars, id: \.self) { index in
                                let adjustedColor = TestScrollView.redForIndex(index, maxIndex: nProgressBars)
                                Rectangle()
                                    .fill(adjustedColor)
                                    .frame(width: 50, height: 10)
                                    .opacity(opacityForBar(n: index))
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 5)
                    }
                }
            }
        }
        
        if selectedScrollTrackerType == .aiAssistant {
            AIAssistantOverlay()
        }
        
        ScrollTrackerTypeToggle(selectedMode: $selectedScrollTrackerType).ignoresSafeArea()
    }
    
}


struct LocalVideoPlayerView: View {
    let videoName: String
    @State private var player: AVPlayer?
    
    var body: some View {
        Group {
            if let player {
                GeometryReader { geoProxy in
                    VideoPlayer(player: player)
                        .frame(width: geoProxy.size.height, height: geoProxy.size.height)
                        .position(x: geoProxy.size.width / 2, y: geoProxy.size.height / 2)
                        .onAppear {
                            player.isMuted = true
                            player.seek(to: .zero)
                            player.play()
                            player.isMuted = true
                            loop(player: player)
                        }
                        .onDisappear {
                            player.pause()
                        }
                }
            } else {
                Color.black.overlay(Text("Video not found").foregroundColor(.white))
            }
            
        }
        .task {
            if player == nil, let url = resolveVideoURLInMain(named: videoName) {
                player = AVPlayer(url: url)
            }
        }
    }
    
    private func resolveVideoURLInMain(named name: String) -> URL? {
        return Bundle.main.url(forResource: name, withExtension: "mp4")
    }
    
    private func loop(player: AVPlayer) {
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
        }
    }
}


