//
//  ScrollTrackerTypeToggle.swift
//  ScrollTrackerPlayground
//
//  Created by Sonam Dhingra on 9/12/25.
//
import SwiftUI

struct ScrollTrackerTypeToggle: View {
    @Binding var selectedMode: ScrollTrackerType
    @State private var isExpanded = false
    
    enum ScrollTrackerType: String, CaseIterable {
        case bottomToast = "Toast"
        case aiAssistant = "AI"
        case redBars = "Bars"
        
        var color: Color {
            switch self {
            case .bottomToast:
                return .blue
            case .aiAssistant:
                return .purple
            case .redBars:
                return .red
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if isExpanded {
                // Expanded options
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(ScrollTrackerType.allCases, id: \.self) { mode in
                        Button(action: {
                            selectMode(mode)
                        }) {
                            HStack(spacing: 8) {
                                Text(mode.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                                
                                if selectedMode == mode {
                                    Image(systemName: "checkmark")
                                        .font(.caption2)
                                        .foregroundColor(.green)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(selectedMode == mode ? Color(.systemGray5) : Color.clear)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 6)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                )
                .transition(.scale.combined(with: .opacity))
            }
            
            // Compact toggle button
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 4) {
//                    Image(systemName: selectedMode.icon)
//                        .font(.caption)
//                        .foregroundColor(selectedMode.color)
                    
                    if !isExpanded {
//                        Image(systemName: "chevron.down")
//                            .font(.caption2)
//                            .foregroundColor(.secondary)
                    }
                }
                .frame(width: isExpanded ? 20 : 32, height: 20)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.leading, 16)
        .padding(.top, 50) // Account for safe area
        .onTapGesture {
            // Tap outside to collapse
            if isExpanded {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isExpanded = false
                }
            }
        }
    }
    
    private func selectMode(_ mode: ScrollTrackerType) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            selectedMode = mode
            isExpanded = false
        }
    }
}


#Preview("ScrollModeToggle Only") {
    @Previewable @State var selectedMode: ScrollTrackerTypeToggle.ScrollTrackerType = .bottomToast
    
    return ZStack {
        Color(.systemGray6).ignoresSafeArea()
        ScrollTrackerTypeToggle(selectedMode: $selectedMode)
    }
}
