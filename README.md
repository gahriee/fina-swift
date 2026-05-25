# Fina — Finance Tracker (macOS)

Fina is a native macOS finance tracking application built with Swift and SwiftUI. It leverages Firebase for real-time data synchronization across devices, offering a seamless and intuitive user experience designed specifically for macOS 13+.

## Architecture Highlights
- **Platform:** macOS 13 (Ventura)+
- **Language:** Swift 5.9
- **UI Framework:** SwiftUI
- **Architecture Pattern:** MVVM (Model-View-ViewModel)
- **State Management:** Native `ObservableObject` and `@Published` (No third-party state libraries)
- **Backend:** Firebase (Auth & Firestore) for cross-device sync

## Features
- **Dashboard:** Overview of total balance, income vs. expense summary, and recent transactions.
- **Transactions:** Add, edit, and delete income and expense entries with ease.
- **Categories:** Organize transactions using simple labels with SF Symbols icons.
- **Reports:** Analyze monthly spending breakdown by category, utilizing native macOS Charts.
- **Settings:** Customize currency symbols, switch themes (System, Light, Dark), and manage data.
- **Budgets & Wallets:** Support for spending limits and multiple accounts.

## Tech Stack & Philosophy
Fina adheres to a strict philosophy: **"If SwiftUI can do it, we don't add a package for it."**

- State management handled natively via SwiftUI.
- Navigation utilizes `TabView` and `NavigationStack`.
- UI icons use Apple's built-in `SF Symbols`.
- Charts use the native macOS 13+ `Charts` framework.
- **Dependencies:** Only one external package is used: `firebase-ios-sdk` via Swift Package Manager (No CocoaPods required).

## Project Structure
- `App/`: App-level configurations like `AppTheme.swift`.
- `Models/`: Plain Swift data structs (`Transaction`, `Category`, `UserSettings`).
- `Services/`: Firebase wrappers for authentication and Firestore operations.
- `ViewModels/`: MVVM logic handling state and data operations.
- `Views/`: SwiftUI UI views organized by feature (Auth, Dashboard, Transactions, Reports, Settings).
- `Components/`: Reusable SwiftUI elements (Cards, Buttons, Formatting).

## System Requirements
- Swift 5.9
- Xcode 15.0+
- macOS 13.6.1 Ventura (Development)
- macOS 13.0+ (Deployment Target)

## Getting Started

1. **Clone the repository.**
2. **Open the project in Xcode.**
3. **Configure Firebase:**
   - Create a project at [console.firebase.google.com](https://console.firebase.google.com/).
   - Add a macOS app and download the `GoogleService-Info.plist`.
   - Drag `GoogleService-Info.plist` into the root of your Xcode project.
4. **App Entitlements:** Ensure the App Sandbox capability has "Outgoing Connections (Client)" enabled in Xcode.
5. **Build and Run (Cmd + R).**

## Acknowledgements
This project is a native macOS Swift adaptation of the Flutter Fina finance tracker, matching functionality with platform-native performance and aesthetics.
