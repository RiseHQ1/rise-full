//
//  RiseStatusBarScrim.swift
//  Rise
//
//  Created by Rise Team on 23/08/2026.
//

import SwiftUI

/// Soft dissolve under the status bar / Dynamic Island so scrolled content
/// fades instead of competing with system chrome.
///
/// Measure `topSafeAreaInset` from a safe-area-respecting ancestor — a
/// `GeometryReader` that also calls `ignoresSafeArea` reports `top == 0`.
public struct RiseStatusBarScrim: View {
    public var topSafeAreaInset: CGFloat
    public var fadeHeight: CGFloat
    public var fill: Color

    public init(
        topSafeAreaInset: CGFloat,
        fadeHeight: CGFloat = RiseTabBar.statusBarFadeHeight,
        fill: Color = RiseTabBar.ambientBottom
    ) {
        self.topSafeAreaInset = topSafeAreaInset
        self.fadeHeight = fadeHeight
        self.fill = fill
    }

    public var body: some View {
        VStack(spacing: 0) {
            LinearGradient(
                stops: [
                    .init(color: fill.opacity(0.88), location: 0),
                    .init(color: fill.opacity(0.58), location: 0.38),
                    .init(color: fill.opacity(0.24), location: 0.70),
                    .init(color: Color.clear, location: 1),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: max(topSafeAreaInset, 1) + fadeHeight)

            Spacer(minLength: 0)
        }
        .ignoresSafeArea(edges: .top)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

public extension View {
    /// Tracks the top safe-area inset for `RiseStatusBarScrim`.
    func riseTrackTopSafeAreaInset(_ inset: Binding<CGFloat>) -> some View {
        onGeometryChange(for: CGFloat.self) { proxy in
            proxy.safeAreaInsets.top
        } action: { newValue in
            inset.wrappedValue = newValue
        }
    }

    /// Overlays the shared status-bar fade (use on pushed feature screens).
    func riseWithStatusBarScrim(fill: Color = RiseTabBar.ambientBottom) -> some View {
        modifier(RiseStatusBarScrimModifier(fill: fill))
    }
}

private struct RiseStatusBarScrimModifier: ViewModifier {
    let fill: Color
    @State private var topSafeAreaInset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .riseTrackTopSafeAreaInset($topSafeAreaInset)
            .overlay {
                RiseStatusBarScrim(topSafeAreaInset: topSafeAreaInset, fill: fill)
            }
    }
}

#Preview("RiseStatusBarScrim") {
    ZStack {
        RiseColors.backgroundAmbient.ignoresSafeArea()
        Text("Scrolling content")
            .font(RiseTypography.title)
            .foregroundStyle(RiseColors.textPrimary)
        RiseStatusBarScrim(topSafeAreaInset: 59)
    }
}
