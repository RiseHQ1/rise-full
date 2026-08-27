//
//  RiseLoadingView.swift
//  Rise
//
//  Created by Rise Team on 21/08/2026.
//

import SwiftUI

/// Calm, minimal loading indicator using Rise accent colors and typography.
public struct RiseLoadingView: View {
    public let message: String?

    public init(_ message: String? = "Finding calm...") {
        self.message = message
    }

    public var body: some View {
        VStack(spacing: RiseSpacing.md) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(RiseColors.accentPrimary)

            if let message {
                Text(message)
                    .font(RiseTypography.body)
                    .foregroundStyle(RiseColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(RiseSpacing.xl)
        .background(RiseColors.backgroundPrimary)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message ?? "Loading content")
    }
}

#Preview("RiseLoadingView") {
    RiseLoadingView("Preparing your daily affirmations...")
}
