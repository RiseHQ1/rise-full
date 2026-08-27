//
//  AppState.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import Observation
import SwiftUI

/// High-level application state managing root flow, tab selection, and global flags.
@Observable
@MainActor
public final class AppState {
    // MARK: - Navigation & Flow

    public var isSplashPresented: Bool

    public var isOnboardingCompleted: Bool {
        didSet {
            UserDefaults.standard.set(isOnboardingCompleted, forKey: AppConstants.StorageKeys.hasCompletedOnboarding)
        }
    }

    public var selectedTab: AppTab
    public var onboardingState: OnboardingState

    // MARK: - Placeholders for Future Infrastructure

    public var isAuthenticated: Bool
    public var isOffline: Bool

    public init() {
        isSplashPresented = true
        isOnboardingCompleted = UserDefaults.standard.bool(forKey: AppConstants.StorageKeys.hasCompletedOnboarding)
        selectedTab = .home
        onboardingState = OnboardingState()
        isAuthenticated = false
        isOffline = false
    }
}
