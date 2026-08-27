//
//  RootView.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Root coordinator presenting Splash → Onboarding → MainTabView.
public struct RootView: View {
    @Environment(AppState.self) private var appState
    @Environment(AppRouter.self) private var appRouter
    @Environment(\.dependencyContainer) private var container

    public init() {}

    public var body: some View {
        if appState.isSplashPresented {
            SplashView {
                withAnimation(RiseAnimations.modalSpring) {
                    appState.isSplashPresented = false
                }
            }
        } else if !appState.isOnboardingCompleted {
            OnboardingContainerView()
                .transition(.opacity)
        } else {
            MainTabView()
                .transition(.opacity)
        }
    }
}

#Preview {
    RootView()
        .environment(PreviewContainer.makeAppState())
        .environment(PreviewContainer.makeAppRouter())
        .environment(\.dependencyContainer, PreviewContainer.makeContainer())
}
