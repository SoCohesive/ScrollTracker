# Scroll Tracker

A multi-platform exploration of visual metaphors for tracking scroll behavior and encouraging mindful content consumption.

## Overview

This project demonstrates three distinct approaches to visualizing scroll progress across iOS, web, and backend platforms. Each method uses different psychological cues to create awareness around digital consumption habits.

## Visuals

1. Bottom Toast 
![Demo of the bottom toast](demo_assets/bottom_toast_demo.GIF)

2. Progressive Bars
![Demo of the progressive bars](demo_assets/bars_demo.GIF)

3. AI Assistant 
![Demo of the ai assistant](demo_assets/ai_assistant_demo.GIF)





## Tracking Methods

### 1. Toast Notifications
Direct text-based intervention that appears after scrolling through specific content thresholds.

### 2. AI Assistant
Conversational "Shroom Sage" that provides contextual suggestions through an interactive interface with random appearance patterns.

### 3. Progress Visualization  
Ambient visual indicators (bars/fog) that intensify with scroll amount, creating peripheral awareness without interrupting content flow.

## Platform Architecture

### iOS (SwiftUI)
- **Current Status**: Complete swift app playground implementation
- **Tech Stack**: SwiftUI, AVKit, iOS 17+
- **Features**: Video content, scroll detection, interactive overlays
- **Entry Point**: `ContentView.swift`

### Web (Planned)
- **Tech Stack**: React/Vue.js + WebGL/Framer animations
- **Features**: Responsive design, touch/mouse scroll detection
- **API Integration**: Real-time usage analytics
- **PWA Support**: Offline-capable, installable

### Backend (TBD)
- **Tech Stack**: Node.js/Typescript + TBD
- **Features**: 
  - Usage analytics and patterns
  - User preference storage
  - A/B testing for different tracking methods
  - API endpoints for cross-platform data sync
  - ONNX embeddings for heuristics 

## Repository Structure
The evolution of this would be: 

```
scroll-tracker/
├── ios/                    # SwiftUI iOS implementation
│   ├── Sources/
│   ├── Resources/
│   └── Package.swift
├── web/                    # Web application
│   ├── src/
│   ├── public/
│   └── package.json
├── backend/               # API and analytics
│   ├── api/
│   ├── models/
│   └── config/
├── shared/               # Cross-platform utilities
│   └── types/
└── docs/                # Documentation and research
```

## iOS Implementation

### Core Components
- **TestScrollView**: Main scroll container with video content
- **AIAssistantOverlay**: Interactive AI guidance system
- **ScrollTrackerTypeToggle**: Mode switcher interface
- **Visual Overlays**: Progress bars, fog effects, toast notifications

### Key Features
- Paging scroll behavior for social media-like experience
- Real-time scroll fraction calculation
- Smooth spring animations
- Custom button styles and gradients

### Requirements
- iOS 17+ (uses `.scrollPosition`)
- Xcode 15+
- AVKit for video playback

## Technical Notes

### Scroll Detection
Uses GeometryReader with frame calculations to track scroll progress across all platforms. iOS implementation:

```swift
scrolledFraction = -minY / (proxy.size.height - screenHeight)
```

### Cross-Platform Considerations
- State management patterns adaptable to React/Vue/Typescript
- Animation systems translatable to CSS/JS
- Visual metaphors consistent across platforms

## Design Philosophy

Each tracker represents different approaches to digital wellness:
- **Direct**: Immediate feedback through notifications
- **Conversational**: Personality-driven engagement
- **Ambient**: Peripheral awareness without interruption

The system avoids judgmental messaging, instead focusing on gentle awareness and user agency in consumption choices.


## Contributing

This project explores the intersection of technology and digital wellness. Contributions should maintain the focus on non-judgmental, user-empowering approaches to content consumption awareness and respect for creator and business needs.

## License

Creative Commons - See LICENSE file for details
