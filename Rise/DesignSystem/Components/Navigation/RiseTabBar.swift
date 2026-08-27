//
//  RiseTabBar.swift
//  Rise
//
//  Created by Rise Team on 22/08/2026.
//

import SwiftUI

/// Floating glass bottom navigation bar shared across post-onboarding tabs.
public struct RiseTabBar: View {
    @Binding public var selectedTab: AppTab
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor
    @Namespace private var tabNamespace

    /// Shared corner treatment: outer bar and selected-tab glass both use capsules
    /// so their radii stay visually aligned.
    public static let shape = Capsule(style: .continuous)

    /// Extra bottom space *inside* scroll content so the last card rests above
    /// the fade + tab chrome. Apply on the inner stack, never the ScrollView.
    public static let contentClearance: CGFloat = 188

    /// Soft fade height above the floating bar.
    public static let topFadeHeight: CGFloat = 64

    /// Soft dissolve below the status-bar region (keeps scrolled titles readable).
    public static let statusBarFadeHeight: CGFloat = 36

    /// Deep navy sampled from the Home art bottom — fade + bottom/top safe-area fill.
    public static let ambientBottom = RiseColors.backgroundAmbient

    public init(selectedTab: Binding<AppTab>) {
        _selectedTab = selectedTab
    }

    public var body: some View {
        HStack(spacing: 2) {
            ForEach(AppTab.allCases) { tab in
                tabItem(tab)
            }
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 6)
        .background {
            ZStack {
                Self.shape
                    .fill(RiseColors.backgroundAmbient.opacity(0.94))
                Self.shape
                    .fill(Color.white.opacity(0.06))
                Self.shape
                    .fill(RiseColors.accentPrimary.opacity(0.10))
            }
        }
        .overlay {
            Self.shape
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.24),
                            RiseColors.accentPrimary.opacity(0.32),
                            Color.white.opacity(0.08),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
        .clipShape(Self.shape)
        .padding(.horizontal, 16)
        .padding(.top, 0)
        .padding(.bottom, 8)
        .animation(RiseAnimations.preferred(RiseAnimations.interactiveSpring, reduceMotion: reduceMotion), value: selectedTab)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(RiseAccessibilityID.tabBar)
    }

    private func tabItem(_ tab: AppTab) -> some View {
        let isSelected = selectedTab == tab
        let title = localizedTitle(for: tab)

        return Button {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            withAnimation(RiseAnimations.preferred(RiseAnimations.interactiveSpring, reduceMotion: reduceMotion)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: tab.systemIconName)
                        .font(isSelected ? RiseTypography.symbolSmall : RiseTypography.subheadline)
                        .foregroundStyle(isSelected ? RiseColors.accentGold : RiseColors.textSecondary)
                        .symbolRenderingMode(.hierarchical)

                    if isSelected && differentiateWithoutColor {
                        Circle()
                            .fill(RiseColors.accentGold)
                            .frame(width: 6, height: 6)
                            .offset(x: 4, y: -2)
                            .accessibilityHidden(true)
                    }
                }

                Text(title)
                    .font(RiseTypography.microSemibold)
                    .foregroundStyle(isSelected ? RiseColors.accentGold : RiseColors.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background {
                if isSelected {
                    selectedGlassBackground
                        .matchedGeometryEffect(id: "selectedTabCapsule", in: tabNamespace)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: RiseIconButtonMetrics.minimumHitTarget)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityHint(isSelected ? "Currently selected" : "Switch to \(title)")
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
        .accessibilityIdentifier(RiseAccessibilityID.tab(tab))
    }

    private func localizedTitle(for tab: AppTab) -> String {
        switch tab {
        case .home: return RiseL10n.tr("tab.home")
        case .discover: return RiseL10n.tr("tab.discover")
        case .journal: return RiseL10n.tr("tab.journal")
        case .progress: return RiseL10n.tr("tab.progress")
        case .profile: return RiseL10n.tr("tab.profile")
        }
    }

    /// Selected pill — opaque fills only (no Material) for identical look on every tab.
    private var selectedGlassBackground: some View {
        Self.shape
            .fill(Color.white.opacity(0.14))
            .overlay {
                Self.shape
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.16),
                                Color.white.opacity(0.05),
                                RiseColors.accentSecondary.opacity(0.07),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay {
                Self.shape
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.30),
                                Color.white.opacity(0.06),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.8
                    )
            }
    }
}

public extension View {
    /// Pads the bottom of scroll *content* (apply on the inner stack, not the
    /// ScrollView) so cards can travel under the overlay fade instead of hard-clipping.
    func riseTabBarScrollClearance() -> some View {
        padding(.bottom, RiseTabBar.contentClearance)
    }
}

#Preview("RiseTabBar") {
    ZStack {
        RiseColors.backgroundPrimary.ignoresSafeArea()
        Image("SplashBackgroundPortrait")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .opacity(0.5)
        VStack {
            Spacer()
            RiseTabBar(selectedTab: .constant(.home))
        }
    }
}
