//
//  SplashHeroMessage.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Centered supporting motivational message for the Splash screen.
public struct SplashHeroMessage: View {
    public init() {}

    public var body: some View {
        Text("Positive thoughts. Better days.\nStronger you.")
            .font(RiseTypography.title)
            .fontWeight(.bold)
            .foregroundStyle(RiseColors.textPrimary)
            .multilineTextAlignment(.center)
            .lineSpacing(RiseSpacing.xxs)
            .shadow(color: Color.black.opacity(0.5), radius: 8, x: 0, y: 2)
            .accessibilityLabel("Positive thoughts. Better days. Stronger you.")
    }
}

#Preview("SplashHeroMessage") {
    SplashHeroMessage()
        .padding(RiseSpacing.xl)
        .background(RiseColors.backgroundPrimary)
}
