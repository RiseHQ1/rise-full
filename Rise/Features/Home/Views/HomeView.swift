//
//  HomeView.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Rise Home screen scaffold matching the approved Homepage reference.
public struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Environment(AppRouter.self) private var appRouter

    @State private var state = HomeState()
    @State private var sharePayload: RiseSharePayload?

    public init() {}

    public var body: some View {
        ZStack {
            backgroundLayer

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {
                    HomeHeaderView(
                        onMenuTap: {
                            state.didTapMenu = true
                            appRouter.push(.motivationCategories, on: .home)
                        },
                        onNotificationsTap: {
                            state.didTapNotifications = true
                            appRouter.push(.notifications, on: .home)
                        }
                    )
                    .riseAppear(delay: 0.0)

                    HomeGreetingView(
                        greetingPrefix: state.greetingPrefix,
                        userName: state.userDisplayName
                    )
                    // Leave the right side open so the boy stays readable.
                    .padding(.trailing, 128)
                    .padding(.top, 2)
                    .riseAppear(delay: 0.06)

                    // Short hero band — boy face lives here before cards.
                    Color.clear
                        .frame(height: 36)

                    HomeThoughtCard(
                        thought: state.currentThought,
                        thoughtCount: state.thoughts.count,
                        thoughtIndex: state.thoughtIndex,
                        isFavorited: state.isThoughtFavorited,
                        onFavoriteToggle: { state.toggleThoughtFavorite() },
                        onShare: { sharePayload = RiseSharePayload(text: state.currentThought.shareText) },
                        onSelectIndex: { state.selectThought(at: $0) }
                    )
                    .riseAppear(delay: 0.12)

                    HomeIntentionCard(
                        intentionText: Binding(
                            get: { state.intentionText },
                            set: { state.intentionText = $0 }
                        ),
                        activeIntention: state.hasActiveIntention ? state.activeIntentionText : nil,
                        onSetIntention: {
                            state.setIntention()
                            appRouter.push(.dailyIntention, on: .home)
                        },
                        onEditIntention: {
                            appRouter.push(.dailyIntention, on: .home)
                        }
                    )
                    .riseAppear(delay: 0.18)

                    HomeQuickActionsCard(
                        onNeedSomething: {
                            state.didTapNeedSomething = true
                            appRouter.push(.needSomethingNow(moodTitle: "stressed"), on: .home)
                        },
                        onSelect: { action in
                            state.selectQuickAction(action)
                            switch action {
                            case .motivate:
                                appRouter.push(.morningBoost, on: .home)
                            case .stressed:
                                appRouter.push(.needSomethingNow(moodTitle: "stressed"), on: .home)
                            case .focus:
                                appRouter.push(.affirmations, on: .home)
                            case .encourage:
                                appRouter.push(.morningBoost, on: .home)
                            case .eveningReflection:
                                appRouter.push(.eveningReflection, on: .home)
                            }
                        }
                    )
                    .riseAppear(delay: 0.24)
                }
                .padding(.horizontal, RiseSpacing.md)
                .padding(.top, RiseSpacing.xs)
                .riseTabBarScrollClearance()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(item: $sharePayload) { payload in
            RiseShareSheet(payload: payload)
        }
    }

    private var backgroundLayer: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                RiseTabBar.ambientBottom

                // User-cropped art: boy already sits high. Pin to top/trailing.
                Image("home_tab_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .topTrailing)
                    .clipped()
                    .accessibilityHidden(true)

                VStack(spacing: 0) {
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.08),
                            Color.clear,
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 56)

                    Spacer(minLength: 0)

                    // Match the art's lower navy so the page and tab chrome feel continuous.
                    LinearGradient(
                        colors: [
                            Color.clear,
                            RiseTabBar.ambientBottom.opacity(0.20),
                            RiseTabBar.ambientBottom.opacity(0.55),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: geo.size.height * 0.26)
                }
                .allowsHitTesting(false)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
        .ignoresSafeArea()
    }
}

#Preview("HomeView") {
    HomeView()
        .environment(AppRouter())
        .environment(AppState())
}
