//
//  FogOverlay.swift
//  ScrollTrackerPlayground
//
//  Created by Sonam Dhingra on 9/12/25.
//

import SwiftUI

struct FogOverlay: View {
    let scrolledFraction: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Left edge fog
                LinearGradient(
                    colors: [
                        Color.gray.opacity(fogOpacity()),
                        Color.clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: fogWidth(screenWidth: geometry.size.width))
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Right edge fog
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.gray.opacity(fogOpacity())
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: fogWidth(screenWidth: geometry.size.width))
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                // Top edge fog
                LinearGradient(
                    colors: [
                        Color.gray.opacity(fogOpacity()),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: fogHeight(screenHeight: geometry.size.height))
                .frame(maxHeight: .infinity, alignment: .top)
                
                // Bottom edge fog
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.gray.opacity(fogOpacity())
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: fogHeight(screenHeight: geometry.size.height))
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .allowsHitTesting(false) // Allow touches to pass through
    }
    
    private func fogOpacity() -> Double {
        // Fog opacity increases as user scrolls more
        return min(Double(scrolledFraction) * 0.6, 0.5)
    }
    
    private func fogWidth(screenWidth: CGFloat) -> CGFloat {
        // Fog width increases from edges toward center
        return screenWidth * scrolledFraction * 0.4
    }
    
    private func fogHeight(screenHeight: CGFloat) -> CGFloat {
        // Fog height increases from edges toward center
        return screenHeight * scrolledFraction * 0.3
    }
}

#Preview("Fog overlay") {
    FogOverlay(scrolledFraction: 0.4)
}
