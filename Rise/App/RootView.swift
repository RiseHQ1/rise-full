//
//  RootView.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Minimal root coordinator view presenting the Splash screen on launch before transitioning to placeholder flow.
public struct RootView: View {
    @Environment(AppState.self) private var appState
    @Environment(AppRouter.self) private var appRouter
    @Environment(\.dependencyContainer) private var container
    
    public init() {}
    
    public var body: some View {
        Group {
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
                ZStack {
                    RiseColors.backgroundPrimary
                        .ignoresSafeArea()
                    
                    VStack(spacing: RiseSpacing.md) {
                        Text(AppConstants.appName)
                            .font(RiseTypography.display)
                            .foregroundStyle(RiseColors.textPrimary)
                        
                        Text("Onboarding Completed")
                            .font(RiseTypography.caption)
                            .foregroundStyle(RiseColors.textSecondary)
                    }
                }
                .transition(.opacity)
            }
        }
    }
}

#Preview {
    RootView()
        .environment(PreviewContainer.makeAppState())
        .environment(PreviewContainer.makeAppRouter())
        .environment(\.dependencyContainer, PreviewContainer.makeContainer())
}
