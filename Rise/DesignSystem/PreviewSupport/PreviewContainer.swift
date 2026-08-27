//
//  PreviewContainer.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Preview environment helper providing mock dependencies and sample states for SwiftUI Previews.
@MainActor
public enum PreviewContainer {
    public static func makeContainer() -> DependencyContainer {
        return DependencyContainer.mock()
    }

    public static func makeAppState(isOnboarded: Bool = true, tab: AppTab = .home) -> AppState {
        let state = AppState()
        state.isOnboardingCompleted = isOnboarded
        state.selectedTab = tab
        return state
    }

    public static func makeAppRouter() -> AppRouter {
        return AppRouter()
    }
}
