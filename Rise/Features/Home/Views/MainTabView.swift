//
//  MainTabView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Post-onboarding shell with floating glass tab bar and per-tab navigation stacks.
public struct MainTabView: View {
    @Environment(AppState.self) private var appState
    @Environment(AppRouter.self) private var appRouter

    /// Measured from a safe-area-respecting container — see `RiseStatusBarScrim`.
    @State private var topSafeAreaInset: CGFloat = 0

    public init() {}

    public var body: some View {
        @Bindable var appState = appState

        // Overlay chrome — do not use safeAreaInset (it shelves the background).
        // Top/bottom fades soften scroll content under system bars, same on every tab.
        ZStack(alignment: .bottom) {
            ZStack {
                tabStack(for: .home) { HomeView() }
                    .opacity(appState.selectedTab == .home ? 1 : 0)
                    .allowsHitTesting(appState.selectedTab == .home)
                tabStack(for: .discover) { DiscoverView() }
                    .opacity(appState.selectedTab == .discover ? 1 : 0)
                    .allowsHitTesting(appState.selectedTab == .discover)
                tabStack(for: .journal) { JournalView() }
                    .opacity(appState.selectedTab == .journal ? 1 : 0)
                    .allowsHitTesting(appState.selectedTab == .journal)
                tabStack(for: .progress) { ProgressTabView() }
                    .opacity(appState.selectedTab == .progress ? 1 : 0)
                    .allowsHitTesting(appState.selectedTab == .progress)
                tabStack(for: .profile) { ProfileView() }
                    .opacity(appState.selectedTab == .profile ? 1 : 0)
                    .allowsHitTesting(appState.selectedTab == .profile)
            }
            .animation(RiseAnimations.standardEase, value: appState.selectedTab)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Tab roots only — pushed feature screens apply their own via
            // `riseWithStatusBarScrim()` so NavigationStack destinations stay covered.
            if isAtTabRoot {
                RiseStatusBarScrim(topSafeAreaInset: topSafeAreaInset)
            }

            if isAtTabRoot {
                VStack(spacing: 0) {
                    // Soft dissolve — transparent to content, same on every tab.
                    LinearGradient(
                        stops: [
                            .init(color: Color.clear, location: 0),
                            .init(color: RiseTabBar.ambientBottom.opacity(0.20), location: 0.22),
                            .init(color: RiseTabBar.ambientBottom.opacity(0.58), location: 0.52),
                            .init(color: RiseTabBar.ambientBottom.opacity(0.88), location: 0.78),
                            .init(color: RiseTabBar.ambientBottom, location: 1),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: RiseTabBar.topFadeHeight)
                    .allowsHitTesting(false)

                    // Opaque fill for pill + home-indicator gap. Shared color so
                    // Discover/Journal/etc. don't show page-card "humps" under the bar.
                    RiseTabBar(selectedTab: $appState.selectedTab)
                        .background(alignment: .bottom) {
                            RiseTabBar.ambientBottom
                                .ignoresSafeArea(edges: .bottom)
                        }
                }
            }
        }
        .riseTrackTopSafeAreaInset($topSafeAreaInset)
        .ignoresSafeArea(.keyboard)
    }

    private var isAtTabRoot: Bool {
        switch appState.selectedTab {
        case .home: return appRouter.homePath.isEmpty
        case .discover: return appRouter.discoverPath.isEmpty
        case .journal: return appRouter.journalPath.isEmpty
        case .progress: return appRouter.progressPath.isEmpty
        case .profile: return appRouter.profilePath.isEmpty
        }
    }

    private func tabStack<Content: View>(
        for tab: AppTab,
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationStack(path: appRouter.binding(for: tab)) {
            content()
                .toolbar(.hidden, for: .navigationBar)
                .navigationBarBackButtonHidden(true)
                .riseEnableSwipeBack()
                .navigationDestination(for: AppRoute.self) { route in
                    FeatureDestinationView(route: route)
                }
        }
    }
}

#Preview("MainTabView") {
    MainTabView()
        .environment(PreviewContainer.makeAppState())
        .environment(PreviewContainer.makeAppRouter())
        .environment(\.dependencyContainer, PreviewContainer.makeContainer())
}
