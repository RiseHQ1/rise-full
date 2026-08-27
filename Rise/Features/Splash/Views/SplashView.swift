//
//  SplashView.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Full-screen Splash view faithfully reproducing the approved Rise sunrise reference design.
///
/// Features the full-bleed SplashBackgroundPortrait 3D artwork, prominent Rise logo,
/// motivational statements, dark translucent purple glass card, and custom rotating gradient loading ring.
public struct SplashView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var state = SplashState()

    public let onFinish: () -> Void

    public init(onFinish: @escaping () -> Void = {}) {
        self.onFinish = onFinish
    }

    public var body: some View {
        ZStack {
            // MARK: - 1. Full-Bleed 3D Portrait Sunrise Artwork

            Image("SplashBackgroundPortrait")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .accessibilityHidden(true)

            // MARK: - 2. Readability Gradient Overlays

            VStack(spacing: 0) {
                // Top subtle scrim for upper logo & headline legibility
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.40),
                        Color.black.opacity(0.12),
                        Color.clear,
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 220)

                Spacer()

                // Bottom subtle scrim for glass card & loading section legibility
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color(hex: "#070611").opacity(0.35),
                        Color(hex: "#070611").opacity(0.85),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 320)
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)

            // MARK: - 3. Foreground Content Layer (Structured with Explicit Safe Margins)

            VStack(spacing: 0) {
                // Top Branding & Hero Statement (Comfortably below Dynamic Island)
                VStack(spacing: RiseSpacing.xs) {
                    SplashLogo(isTaglineVisible: state.isTaglineVisible)
                        .opacity(state.isLogoVisible ? 1.0 : 0.0)
                        .scaleEffect(state.isLogoVisible ? 1.0 : 0.94)

                    SplashHeroMessage()
                        .opacity(state.isMessageVisible ? 1.0 : 0.0)
                        .offset(y: state.isMessageVisible ? 0 : 8)
                }
                .padding(.top, 54)

                Spacer(minLength: RiseSpacing.md)

                // Bottom Dark Glass Card & Loading Indicator (Comfortably above Home Bar)
                VStack(spacing: RiseSpacing.md) {
                    SplashGlassCard()
                        .padding(.horizontal, RiseSpacing.lg)
                        .opacity(state.isCardVisible ? 1.0 : 0.0)
                        .offset(y: state.isCardVisible ? 0 : 16)

                    SplashLoadingView()
                        .opacity(state.isLoadingVisible ? 1.0 : 0.0)
                }
                .padding(.bottom, 44)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(state.isCompleted ? 0.0 : 1.0)
        }
        .onAppear {
            state.start(reduceMotion: reduceMotion, onFinish: onFinish)
        }
    }
}

#Preview("SplashView") {
    SplashView()
}
