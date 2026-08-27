//
//  SplashLoadingView.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Animated loading section for the Splash screen with custom gradient ring and status text.
public struct SplashLoadingView: View {
    public init() {}

    public var body: some View {
        VStack(spacing: RiseSpacing.xs) {
            RiseLoadingRing(size: 26, lineWidth: 2.5)

            Text("Preparing your daily boost...")
                .font(RiseTypography.caption)
                .foregroundStyle(RiseColors.textSecondary)
                .shadow(color: Color.black.opacity(0.5), radius: 4, x: 0, y: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Preparing your daily boost")
    }
}

#Preview("SplashLoadingView") {
    SplashLoadingView()
        .padding(RiseSpacing.xl)
        .background(RiseColors.backgroundPrimary)
}
